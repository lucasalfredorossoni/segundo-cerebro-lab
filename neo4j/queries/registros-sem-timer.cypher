// Auditoria: registros de tarefa ou leitura sem timer.
// Pela regra central, nenhum desses itens pode virar oficial sem TEM_TIMER.

MATCH (registro)
WHERE registro:Tarefa OR registro:Leitura
WITH registro
WHERE NOT (registro)-[:TEM_TIMER]->(:Timer)
RETURN
  labels(registro) AS tipos,
  registro.id AS id,
  coalesce(registro.titulo, registro.nome) AS titulo,
  registro.status AS status,
  registro.clickup_ready AS clickup_ready
ORDER BY status, titulo;
