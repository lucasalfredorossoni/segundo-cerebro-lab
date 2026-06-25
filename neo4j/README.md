# Neo4j Knowledge Graph

MVP do grafo de conhecimento do Segundo Cerebro Lab.

Esta pasta guarda scripts Cypher seguros e versionaveis para modelar o lab como
grafo. Os dados de exemplo sao ficticios e nao incluem dados pessoais reais,
dados clinicos, senhas, tokens ou exports privados.

## Estrutura

```text
neo4j/
  schema/
    segundo-cerebro-schema.cypher
  seeds/
    seed-mvp.cypher
  queries/
    mapa-geral.cypher
    registros-sem-timer.cypher
    leituras-que-geraram-tarefas.cypher
  README.md
```

## Modelo inicial

Nos principais:

- `Projeto`
- `Ferramenta`
- `Processo`
- `Regra`
- `Estado`
- `Leitura`
- `Tarefa`
- `Conceito`
- `Timer`

Relacoes principais:

- `USA`
- `DEFINE_ESCOPO`
- `IMPLEMENTA`
- `VERSIONA`
- `EXIGE`
- `CONDICIONA`
- `GERA`
- `TEM_TIMER`
- `CONECTA`

## Regra central

Nenhum registro de tarefa, leitura ou execucao vira oficial sem timer ou metrica
de tempo.

No grafo, isso aparece como:

- uma `Regra` versionada;
- estados `rascunho`, `conferencia`, `confirmacao_lucas` e `registro_oficial`;
- tarefas e leituras conectadas a `Timer` por `TEM_TIMER`;
- queries de auditoria para achar registros sem timer.

## Como executar no Neo4j Browser

1. Abra o Neo4j Browser.
2. Rode `schema/segundo-cerebro-schema.cypher`.
3. Rode `seeds/seed-mvp.cypher`.
4. Rode as queries em `queries/`.

## Instancia local deste lab

Esta maquina usa uma instalacao local, sem `sudo`, em:

- JDK: `~/.local/opt/jdk-21`
- Neo4j: `~/.local/opt/neo4j`
- Config local: `.cerebro/neo4j.env`

O arquivo `.cerebro/neo4j.env` fica fora do Git e guarda a senha local.

Comandos operacionais:

```bash
scripts/neo4j-local.sh start
scripts/neo4j-local.sh status
scripts/neo4j-local.sh load
scripts/neo4j-local.sh query neo4j/queries/registros-sem-timer.cypher
scripts/neo4j-local.sh stop
```

Browser local:

```text
http://127.0.0.1:7474
```

## Como executar com cypher-shell

```bash
cypher-shell -u neo4j -p '<senha>' -f neo4j/schema/segundo-cerebro-schema.cypher
cypher-shell -u neo4j -p '<senha>' -f neo4j/seeds/seed-mvp.cypher
cypher-shell -u neo4j -p '<senha>' -f neo4j/queries/mapa-geral.cypher
```

Nao coloque senha real em arquivos versionados.

## Proximo passo

Quando o modelo estabilizar, conectar este grafo ao comando `cerebro` para:

- registrar triagens oficiais;
- auditar tarefas sem timer;
- mapear leituras que geram tarefas;
- preparar sincronizacao futura com ClickUp.
