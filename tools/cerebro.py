#!/usr/bin/env python3
"""CLI operacional do Segundo Cerebro Lab."""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
from dataclasses import dataclass
from datetime import datetime, timedelta
from pathlib import Path


APP_NAME = "cerebro"
TIMER_FILE = "timers.json"


SENSITIVE_PATTERNS: tuple[tuple[str, re.Pattern[str]], ...] = (
    ("email", re.compile(r"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b")),
    ("cpf", re.compile(r"\b\d{3}\.?\d{3}\.?\d{3}-?\d{2}\b")),
    ("token", re.compile(r"\b(?:ghp|gho|ghu|github_pat|sk)-[A-Za-z0-9_=-]{12,}\b")),
    ("segredo", re.compile(r"\b(token|senha|password|secret|api[_-]?key)\b", re.I)),
    ("clinico", re.compile(r"\b(clinico|clinica|diagnostico|prontuario|paciente)\b", re.I)),
)


@dataclass
class Paths:
    root: Path
    state: Path
    timer_file: Path
    triage_drafts: Path
    triage_official: Path


def now_local() -> datetime:
    return datetime.now().astimezone()


def iso_now() -> str:
    return now_local().isoformat(timespec="seconds")


def slugify(text: str) -> str:
    lowered = text.lower().strip()
    normalized = re.sub(r"[^a-z0-9]+", "-", lowered)
    normalized = normalized.strip("-")
    return normalized[:70] or "registro"


def parse_clock(value: str) -> datetime:
    hour, minute = value.split(":", 1)
    base = now_local()
    return base.replace(hour=int(hour), minute=int(minute), second=0, microsecond=0)


def minutes_between(start: str | None, end: str | None) -> int | None:
    if not start or not end:
        return None
    started = parse_clock(start)
    finished = parse_clock(end)
    if finished < started:
        finished = finished + timedelta(days=1)
    return round((finished - started).total_seconds() / 60)


def run(args: list[str], cwd: Path) -> tuple[int, str]:
    try:
        proc = subprocess.run(
            args,
            cwd=cwd,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
        )
    except FileNotFoundError:
        return 127, f"comando nao encontrado: {args[0]}"
    return proc.returncode, proc.stdout.strip()


def find_root(explicit: str | None) -> Path:
    if explicit:
        return Path(explicit).expanduser().resolve()

    env_root = os.environ.get("CEREBRO_LAB_ROOT")
    if env_root:
        return Path(env_root).expanduser().resolve()

    current = Path.cwd().resolve()
    for path in (current, *current.parents):
        if (path / ".git").exists() and (path / "README.md").exists():
            return path
    return current


def build_paths(root: Path) -> Paths:
    state = root / ".cerebro"
    return Paths(
        root=root,
        state=state,
        timer_file=state / TIMER_FILE,
        triage_drafts=root / "data" / "processed" / "triagem" / "drafts",
        triage_official=root / "data" / "processed" / "triagem" / "official",
    )


def ensure_state(paths: Paths) -> None:
    paths.state.mkdir(parents=True, exist_ok=True)
    if not paths.timer_file.exists():
        paths.timer_file.write_text("[]\n", encoding="utf-8")


def read_timers(paths: Paths) -> list[dict[str, object]]:
    ensure_state(paths)
    try:
        data = json.loads(paths.timer_file.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        data = []
    return data if isinstance(data, list) else []


def write_timers(paths: Paths, timers: list[dict[str, object]]) -> None:
    ensure_state(paths)
    paths.timer_file.write_text(
        json.dumps(timers, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )


def detect_sensitive(text: str) -> list[str]:
    found: list[str] = []
    for name, pattern in SENSITIVE_PATTERNS:
        if pattern.search(text):
            found.append(name)
    return sorted(set(found))


def safe_text(text: str, sensitive: list[str]) -> str:
    if not sensitive:
        return text.strip()
    return "[conteudo removido: possivel dado sensivel detectado]"


def timer_fields(args: argparse.Namespace) -> tuple[int | None, str]:
    duration = args.minutes
    calculated = minutes_between(args.start, args.end)
    if duration is None:
        duration = calculated

    evidence_parts = []
    if args.start and args.end:
        evidence_parts.append(f"janela {args.start}-{args.end}")
    if args.minutes is not None:
        evidence_parts.append(f"duracao informada {args.minutes} min")
    if args.estimate is not None:
        evidence_parts.append(f"estimativa {args.estimate} min")
    evidence = "; ".join(evidence_parts) or "sem evidencia de timer"
    return duration, evidence


def write_triage_file(
    paths: Paths,
    title: str,
    markdown: str,
    official: bool,
    dry_run: bool,
) -> Path | None:
    base_dir = paths.triage_official if official else paths.triage_drafts
    filename = f"{now_local().strftime('%Y%m%d-%H%M%S')}-{slugify(title)}.md"
    target = base_dir / filename

    if dry_run:
        print(markdown)
        return None

    base_dir.mkdir(parents=True, exist_ok=True)
    target.write_text(markdown, encoding="utf-8")
    return target


def triage_markdown(args: argparse.Namespace, official: bool) -> tuple[str, bool]:
    raw_text = args.text or ""
    if args.text_file:
        raw_text = Path(args.text_file).expanduser().read_text(encoding="utf-8")

    duration, evidence = timer_fields(args)
    sensitive = detect_sensitive("\n".join([args.title, raw_text, args.source or ""]))
    has_timer = duration is not None or args.estimate is not None or (args.start and args.end)
    confirmed = bool(args.confirm_lucas)

    if sensitive:
        can_official = False
        block = "dados_sensiveis"
    elif not has_timer:
        can_official = False
        block = "bloqueado_por_timer"
    elif not confirmed:
        can_official = False
        block = "pendente_confirmacao_lucas"
    else:
        can_official = True
        block = "nenhum"

    official_record = bool(official and can_official)
    phase = "registro_oficial" if official_record else "rascunho"
    cleaned_text = safe_text(raw_text, sensitive)
    spent = duration if duration is not None else ""
    estimate = args.estimate if args.estimate is not None else ""

    md = f"""# Triagem com Timer

## Status

- fase: {phase}
- pode_virar_oficial: {"sim" if can_official else "nao"}
- motivo_bloqueio: {block}

## Item

- tipo: {args.kind}
- titulo: {args.title}
- descricao: {cleaned_text or "sem descricao adicional"}
- origem: {args.source or "entrada manual"}
- prioridade: {args.priority}

## Timer

- timer_inicio: {args.start or ""}
- timer_fim: {args.end or ""}
- duracao_minutos: {spent}
- tempo_estimado_minutos: {estimate}
- tempo_gasto_minutos: {spent}
- janela_de_execucao: {args.window or ""}
- evidencia_do_timer: {evidence}

## Conferencia

- dados_sensiveis_detectados: {"sim" if sensitive else "nao"}
- categorias_sensiveis: {", ".join(sensitive) if sensitive else "nenhuma"}
- ajustes_necessarios: {"enviar versao segura" if sensitive else "nenhum"}
- perguntas_para_lucas: {"nenhuma" if confirmed else "Lucas confirma este item?"}

## Confirmacao do Lucas

- confirmado_por_lucas: {"sim" if confirmed else "nao"}
- confirmado_em: {iso_now() if confirmed else ""}
- observacao: {"confirmado via CLI" if confirmed else "aguardando confirmacao"}

## Registro Oficial

- registrar_agora: {"sim" if official_record else "nao"}
- motivo: {"criterios atendidos" if official_record else block}
- resumo_oficial_proposto: {args.title} ({args.kind}) com timer obrigatorio.

## Preparacao ClickUp

- clickup_ready: {"sim" if has_timer and not sensitive else "nao"}
- clickup_task_name: {args.title}
- clickup_description: {cleaned_text or args.title}
- clickup_time_estimate_minutes: {estimate}
- clickup_time_spent_minutes: {spent}
- clickup_tags: triagem, timer, {args.kind}
- clickup_custom_fields:
  - fase_triagem: {phase}
  - timer_obrigatorio: true
  - confirmado_por_lucas: {"true" if confirmed else "false"}
"""
    return md, official_record


def cmd_status(args: argparse.Namespace) -> int:
    paths = build_paths(find_root(args.root))
    ensure_state(paths)
    timers = read_timers(paths)
    active = [timer for timer in timers if not timer.get("stopped_at")]

    print(f"{APP_NAME}: {paths.root}")
    code, branch = run(["git", "branch", "--show-current"], paths.root)
    if code == 0 and branch:
        print(f"branch: {branch}")
    code, status = run(["git", "status", "--short", "--branch"], paths.root)
    if code == 0:
        print(status)

    drafts = (
        len(list(paths.triage_drafts.glob("*.md")))
        if paths.triage_drafts.exists()
        else 0
    )
    official = (
        len(list(paths.triage_official.glob("*.md")))
        if paths.triage_official.exists()
        else 0
    )
    print(f"triagens: {drafts} rascunho(s), {official} oficial(is)")
    print(f"timers ativos: {len(active)}")
    for timer in active:
        print(f"- {timer['name']} desde {timer['started_at']}")

    if shutil.which("gh"):
        code, prs = run(
            ["gh", "pr", "list", "--json", "number,title,headRefName,url"],
            paths.root,
        )
        if code == 0:
            try:
                parsed_prs = json.loads(prs)
            except json.JSONDecodeError:
                parsed_prs = []
            if parsed_prs:
                print("prs abertos:")
                for pr in parsed_prs:
                    print(
                        f"- #{pr['number']} {pr['title']} "
                        f"({pr['headRefName']}) {pr['url']}"
                    )
            else:
                print("prs abertos: 0")
    return 0


def cmd_resumo(args: argparse.Namespace) -> int:
    paths = build_paths(find_root(args.root))
    print("# Resumo do Segundo Cerebro Lab")
    print(f"\nGerado em: {iso_now()}")
    print(f"\nRoot: {paths.root}")

    roadmap = paths.root / "docs" / "roadmap.md"
    if roadmap.exists():
        print("\n## Roadmap")
        lines = roadmap.read_text(encoding="utf-8").splitlines()
        for line in lines[:40]:
            print(line)

    print("\n## Git")
    code, commits = run(["git", "log", "--oneline", "--decorate", "-5"], paths.root)
    print(commits if code == 0 else "git indisponivel")
    return 0


def cmd_timer_start(args: argparse.Namespace) -> int:
    paths = build_paths(find_root(args.root))
    timers = read_timers(paths)
    if any(timer["name"] == args.name and not timer.get("stopped_at") for timer in timers):
        print(f"timer ja esta ativo: {args.name}", file=sys.stderr)
        return 2

    timers.append(
        {
            "name": args.name,
            "note": args.note or "",
            "started_at": iso_now(),
            "stopped_at": "",
            "minutes": None,
        }
    )
    write_timers(paths, timers)
    print(f"timer iniciado: {args.name}")
    return 0


def cmd_timer_stop(args: argparse.Namespace) -> int:
    paths = build_paths(find_root(args.root))
    timers = read_timers(paths)
    for timer in reversed(timers):
        if timer["name"] == args.name and not timer.get("stopped_at"):
            started = datetime.fromisoformat(str(timer["started_at"]))
            stopped = now_local()
            minutes = max(1, round((stopped - started).total_seconds() / 60))
            timer["stopped_at"] = stopped.isoformat(timespec="seconds")
            timer["minutes"] = minutes
            write_timers(paths, timers)
            print(f"timer encerrado: {args.name} ({minutes} min)")
            if args.triagem:
                triage_args = argparse.Namespace(
                    kind=args.kind,
                    title=args.title or args.name,
                    text=args.text or str(timer.get("note") or ""),
                    text_file=None,
                    source=args.source or f"timer:{args.name}",
                    priority=args.priority,
                    start=started.strftime("%H:%M"),
                    end=stopped.strftime("%H:%M"),
                    minutes=minutes,
                    estimate=args.estimate,
                    window=args.window or "",
                    confirm_lucas=args.confirm_lucas,
                    official=args.official,
                    dry_run=False,
                )
                markdown, official_record = triage_markdown(triage_args, args.official)
                target = write_triage_file(
                    paths,
                    triage_args.title,
                    markdown,
                    official_record,
                    False,
                )
                print(f"triagem criada a partir do timer: {target}")
            return 0
    print(f"timer ativo nao encontrado: {args.name}", file=sys.stderr)
    return 2


def cmd_timer_list(args: argparse.Namespace) -> int:
    paths = build_paths(find_root(args.root))
    timers = read_timers(paths)
    if not timers:
        print("nenhum timer registrado")
        return 0
    for timer in timers:
        status = "ativo" if not timer.get("stopped_at") else "fechado"
        print(
            f"{status}: {timer['name']} | "
            f"inicio={timer['started_at']} | min={timer.get('minutes')}"
        )
    return 0


def cmd_triagem_create(args: argparse.Namespace) -> int:
    paths = build_paths(find_root(args.root))
    markdown, official = triage_markdown(args, args.official)
    target = write_triage_file(paths, args.title, markdown, official, args.dry_run)
    if args.dry_run:
        return 0
    print(f"triagem criada: {target}")
    if not official:
        print("status: rascunho; registro oficial exige timer e confirmacao do Lucas")
    return 0


def cmd_issue_list(args: argparse.Namespace) -> int:
    paths = build_paths(find_root(args.root))
    if not shutil.which("gh"):
        print("gh nao encontrado", file=sys.stderr)
        return 127
    cmd = ["gh", "issue", "list", "--limit", str(args.limit)]
    if args.state:
        cmd.extend(["--state", args.state])
    code, out = run(cmd, paths.root)
    print(out)
    return code


def cmd_issue_create(args: argparse.Namespace) -> int:
    paths = build_paths(find_root(args.root))
    if not shutil.which("gh"):
        print("gh nao encontrado", file=sys.stderr)
        return 127
    body = args.body or ""
    if args.body_file:
        body = Path(args.body_file).expanduser().read_text(encoding="utf-8")
    sensitive = detect_sensitive("\n".join([args.title, body]))
    if sensitive:
        print(
            "issue bloqueada: possivel dado sensivel detectado "
            f"({', '.join(sensitive)})",
            file=sys.stderr,
        )
        return 2
    cmd = ["gh", "issue", "create", "--title", args.title, "--body", body]
    for label in args.label or []:
        cmd.extend(["--label", label])
    code, out = run(cmd, paths.root)
    print(out)
    return code


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog=APP_NAME)
    parser.add_argument("--root", help="raiz do Segundo Cerebro Lab")
    sub = parser.add_subparsers(dest="command", required=True)

    status = sub.add_parser("status", help="mostra estado do lab")
    status.set_defaults(func=cmd_status)

    resumo = sub.add_parser("resumo", help="gera resumo operacional")
    resumo.set_defaults(func=cmd_resumo)

    timer = sub.add_parser("timer", help="controla timers locais")
    timer_sub = timer.add_subparsers(dest="timer_command", required=True)
    timer_start = timer_sub.add_parser("start", help="inicia timer")
    timer_start.add_argument("name")
    timer_start.add_argument("--note")
    timer_start.set_defaults(func=cmd_timer_start)

    timer_stop = timer_sub.add_parser("stop", help="encerra timer")
    timer_stop.add_argument("name")
    timer_stop.add_argument(
        "--triagem",
        action="store_true",
        help="cria triagem com o tempo medido",
    )
    timer_stop.add_argument("--kind", choices=["tarefa", "leitura", "execucao"], default="execucao")
    timer_stop.add_argument("--title")
    timer_stop.add_argument("--text", default="")
    timer_stop.add_argument("--source", default="")
    timer_stop.add_argument("--priority", choices=["baixa", "media", "alta"], default="media")
    timer_stop.add_argument("--estimate", type=int)
    timer_stop.add_argument("--window", default="")
    timer_stop.add_argument("--confirm-lucas", action="store_true")
    timer_stop.add_argument("--official", action="store_true")
    timer_stop.set_defaults(func=cmd_timer_stop)

    timer_list = timer_sub.add_parser("list", help="lista timers")
    timer_list.set_defaults(func=cmd_timer_list)

    triagem = sub.add_parser("triagem", help="cria registros de triagem")
    triagem_sub = triagem.add_subparsers(dest="triagem_command", required=True)
    triagem_create = triagem_sub.add_parser("create", help="cria rascunho ou oficial")
    triagem_create.add_argument("--kind", choices=["tarefa", "leitura", "execucao"], required=True)
    triagem_create.add_argument("--title", required=True)
    triagem_create.add_argument("--text", default="")
    triagem_create.add_argument("--text-file")
    triagem_create.add_argument("--source", default="entrada manual")
    triagem_create.add_argument("--priority", choices=["baixa", "media", "alta"], default="media")
    triagem_create.add_argument("--start")
    triagem_create.add_argument("--end")
    triagem_create.add_argument("--minutes", type=int)
    triagem_create.add_argument("--estimate", type=int)
    triagem_create.add_argument("--window", default="")
    triagem_create.add_argument("--confirm-lucas", action="store_true")
    triagem_create.add_argument("--official", action="store_true")
    triagem_create.add_argument("--dry-run", action="store_true")
    triagem_create.set_defaults(func=cmd_triagem_create)

    issue = sub.add_parser("issue", help="atalhos para GitHub Issues")
    issue_sub = issue.add_subparsers(dest="issue_command", required=True)
    issue_list = issue_sub.add_parser("list", help="lista issues")
    issue_list.add_argument("--limit", type=int, default=10)
    issue_list.add_argument("--state", choices=["open", "closed", "all"])
    issue_list.set_defaults(func=cmd_issue_list)

    issue_create = issue_sub.add_parser("create", help="cria issue no GitHub")
    issue_create.add_argument("--title", required=True)
    issue_create.add_argument("--body", default="")
    issue_create.add_argument("--body-file")
    issue_create.add_argument("--label", action="append")
    issue_create.set_defaults(func=cmd_issue_create)

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    return int(args.func(args))


if __name__ == "__main__":
    raise SystemExit(main())
