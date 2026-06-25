# Segundo Cerebro Lab

Laboratorio operacional do Segundo Cerebro: dados, automacoes, estudos,
conteudo e integracoes com ClickUp, Canva, Drive e GitHub.

Este repositorio existe para tirar o Segundo Cerebro do campo das ideias e
transforma-lo em um sistema operacional: documentado, automatizavel e facil de
evoluir.

## Mapa do repositorio

- `docs/`: decisoes, processos, arquitetura e roadmap.
- `automations/`: scripts, jobs e fluxos automatizados.
- `integrations/`: contratos e notas de integracao com ferramentas externas.
- `data/`: dados de trabalho, amostras e esquemas sem informacao sensivel.
- `content/`: pautas, formatos e materiais publicaveis.
- `experiments/`: testes rapidos antes de virar processo oficial.
- `neo4j/`: schema, seed e queries do grafo de conhecimento.
- `.github/`: templates para issues e pull requests.

## Comando local

Este lab inclui o comando `cerebro`, um CLI operacional para status, timers,
triagem com timer obrigatorio, issues e resumos.

```bash
scripts/install-cerebro.sh
cerebro status
```

Veja [docs/06-cerebro-cli.md](docs/06-cerebro-cli.md) para detalhes.

## Como trabalhar aqui

1. Registre a intencao em `docs/roadmap.md` antes de construir algo grande.
2. Use `experiments/` para prototipos curtos e descarte o que nao provar valor.
3. Promova para `automations/`, `integrations/` ou `content/` quando virar rotina.
4. Documente decisoes relevantes em `docs/decisions/`.
5. Nunca versione credenciais, tokens, exports privados ou dados pessoais.

## Status

Base operacional criada. O proximo ciclo deve escolher a primeira automacao real
e conectar uma fonte externa pequena, com escopo controlado e verificavel.
