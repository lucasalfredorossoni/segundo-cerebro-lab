# Stack

## Padrao inicial

- Documentacao em Markdown.
- Automacoes preferencialmente em Python quando houver codigo.
- Configuracao local por `.env`, usando `.env.example` como referencia.
- Dados sensiveis fora do Git.

## Criterio para adicionar dependencia

Adicione uma dependencia quando ela:

- elimina complexidade real;
- melhora seguranca ou confiabilidade;
- sera usada por mais de um experimento;
- tem manutencao ativa e documentacao suficiente.

## Ferramentas sugeridas

- `ruff` para lint e organizacao de imports.
- `black` para formatacao Python.
- `pytest` para testes de automacoes.
- `markdownlint` para manter documentacao consistente.
