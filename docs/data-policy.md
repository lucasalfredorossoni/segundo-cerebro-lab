# Politica de Dados

## Pode versionar

- Dados ficticios.
- Amostras anonimizadas.
- Esquemas, contratos e dicionarios de dados.
- Relatorios publicos ou explicitamente liberados.

## Nao pode versionar

- Tokens, chaves de API e credenciais.
- Exports privados de clientes, projetos ou contas pessoais.
- Dados pessoais identificaveis.
- Arquivos grandes que deveriam estar em Drive, banco ou storage dedicado.

## Organizacao

- `data/samples/`: exemplos pequenos e seguros.
- `data/schemas/`: definicoes de campos, formatos e contratos.
- `data/processed/`: saidas derivadas que podem ser regeneradas.

Antes de commitar dados, trate todo arquivo como publico.
