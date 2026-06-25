// Mapa geral do MVP do Segundo Cerebro Lab.
// Mostra os principais nos e relacoes do grafo.

MATCH path = (n)-[r]->(m)
WHERE any(label IN labels(n) WHERE label IN [
  "Projeto",
  "Ferramenta",
  "Processo",
  "Regra",
  "Estado",
  "Leitura",
  "Tarefa",
  "Conceito",
  "Timer"
])
RETURN path
LIMIT 100;
