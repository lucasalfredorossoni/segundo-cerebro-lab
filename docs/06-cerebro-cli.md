# Cerebro CLI

O `cerebro` e o comando central do Segundo Cerebro Lab.

Ele foi criado para operar rotinas locais sem misturar rascunho, timer,
confirmacao e registro oficial.

## Instalar

```bash
scripts/install-cerebro.sh
```

O instalador cria um link em `~/.local/bin/cerebro`.

## Comandos

### Status

```bash
cerebro status
```

Mostra raiz do lab, branch atual, estado do Git, triagens locais, timers ativos
e PRs abertos quando `gh` estiver autenticado.

### Timer

```bash
cerebro timer start "leitura-artigo" --note "sessao de estudo"
cerebro timer stop "leitura-artigo"
cerebro timer list
```

Timers ficam em `.cerebro/timers.json`, fora do Git.

Tambem da para encerrar um timer ja criando rascunho de triagem:

```bash
cerebro timer stop "leitura-artigo" --triagem --kind leitura
```

### Triagem

```bash
cerebro triagem create \
  --kind leitura \
  --title "Leitura publica sobre organizacao" \
  --minutes 25 \
  --text "Leitura de artigo publico para gerar uma acao."
```

Por padrao, a triagem vira rascunho local em
`data/processed/triagem/drafts/`, que tambem fica fora do Git.

Para registro oficial, os criterios precisam estar completos:

```bash
cerebro triagem create \
  --kind execucao \
  --title "Revisar quadro semanal" \
  --minutes 20 \
  --confirm-lucas \
  --official \
  --text "Execucao segura e ficticia."
```

Sem timer, o item fica bloqueado por `bloqueado_por_timer`.

Sem confirmacao do Lucas, o item fica como `pendente_confirmacao_lucas`.

Se houver possivel dado sensivel, o conteudo e removido do registro gerado e o
item fica bloqueado por `dados_sensiveis`.

### Issues

```bash
cerebro issue list
cerebro issue create --title "Nova automacao" --body "Descrever escopo."
```

Os comandos de issue usam `gh`, entao dependem de autenticacao GitHub.

### Resumo

```bash
cerebro resumo
```

Gera um resumo operacional com roadmap e ultimos commits.

## Seguranca

O CLI nao versiona estado local, timers ou registros gerados. As pastas abaixo
sao ignoradas:

- `.cerebro/`
- `data/processed/triagem/drafts/`
- `data/processed/triagem/official/`

Antes de promover qualquer item para registro oficial, confirme:

- existe timer ou metrica de tempo;
- nao ha dado pessoal real;
- nao ha dado clinico;
- nao ha senha, token ou export privado;
- Lucas confirmou explicitamente.
