// Schema inicial do Segundo Cerebro Lab para Neo4j.
// Seguro para versionamento: nao contem dados reais ou segredos.

CREATE CONSTRAINT projeto_id_unique IF NOT EXISTS
FOR (n:Projeto)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT ferramenta_id_unique IF NOT EXISTS
FOR (n:Ferramenta)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT processo_id_unique IF NOT EXISTS
FOR (n:Processo)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT regra_id_unique IF NOT EXISTS
FOR (n:Regra)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT estado_id_unique IF NOT EXISTS
FOR (n:Estado)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT leitura_id_unique IF NOT EXISTS
FOR (n:Leitura)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT tarefa_id_unique IF NOT EXISTS
FOR (n:Tarefa)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT conceito_id_unique IF NOT EXISTS
FOR (n:Conceito)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT timer_id_unique IF NOT EXISTS
FOR (n:Timer)
REQUIRE n.id IS UNIQUE;

CREATE INDEX tarefa_status_index IF NOT EXISTS
FOR (n:Tarefa)
ON (n.status);

CREATE INDEX tarefa_tipo_index IF NOT EXISTS
FOR (n:Tarefa)
ON (n.tipo);

CREATE INDEX leitura_status_index IF NOT EXISTS
FOR (n:Leitura)
ON (n.status);

CREATE INDEX timer_minutos_index IF NOT EXISTS
FOR (n:Timer)
ON (n.duracao_minutos);

CREATE INDEX conceito_nome_index IF NOT EXISTS
FOR (n:Conceito)
ON (n.nome);
