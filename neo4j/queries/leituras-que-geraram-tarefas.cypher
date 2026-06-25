// Leituras que geraram tarefas e seus timers.
// Ajuda a rastrear estudo -> acao -> tempo gasto.

MATCH (leitura:Leitura)-[:GERA]->(tarefa:Tarefa)
OPTIONAL MATCH (leitura)-[:TEM_TIMER]->(timerLeitura:Timer)
OPTIONAL MATCH (tarefa)-[:TEM_TIMER]->(timerTarefa:Timer)
RETURN
  leitura.titulo AS leitura,
  timerLeitura.duracao_minutos AS minutos_leitura,
  tarefa.titulo AS tarefa,
  tarefa.status AS status_tarefa,
  timerTarefa.duracao_minutos AS minutos_tarefa,
  tarefa.clickup_ready AS clickup_ready
ORDER BY leitura, tarefa;
