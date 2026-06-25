// Seed MVP ficticio do Segundo Cerebro Lab.
// Nao inclui dados pessoais reais, dados clinicos, senhas, tokens ou exports.

MERGE (lab:Projeto {id: "projeto-segundo-cerebro-lab"})
SET
  lab.nome = "Segundo Cerebro Lab",
  lab.descricao = "Laboratorio operacional ficticio para automacoes, estudos e conteudo",
  lab.status = "ativo";

MERGE (repo:Ferramenta {id: "ferramenta-github"})
SET repo.nome = "GitHub", repo.tipo = "versionamento";

MERGE (cli:Ferramenta {id: "ferramenta-cerebro-cli"})
SET cli.nome = "cerebro CLI", cli.tipo = "operacao_local";

MERGE (neo4j:Ferramenta {id: "ferramenta-neo4j"})
SET neo4j.nome = "Neo4j", neo4j.tipo = "grafo";

MERGE (clickup:Ferramenta {id: "ferramenta-clickup"})
SET clickup.nome = "ClickUp", clickup.tipo = "gestao_tarefas", clickup.status = "futuro";

MERGE (triagem:Processo {id: "processo-triagem-com-timer"})
SET
  triagem.nome = "Triagem com timer obrigatorio",
  triagem.descricao = "Fluxo de rascunho, conferencia, confirmacao e registro oficial";

MERGE (grafo:Processo {id: "processo-grafo-conhecimento"})
SET
  grafo.nome = "Grafo de conhecimento",
  grafo.descricao = "Representacao de projetos, leituras, tarefas, regras e timers";

MERGE (regraTimer:Regra {id: "regra-timer-obrigatorio"})
SET
  regraTimer.nome = "Timer obrigatorio",
  regraTimer.descricao = "Registro oficial exige timer ou metrica de tempo",
  regraTimer.versao = "1.0.0",
  regraTimer.status = "ativa";

MERGE (rascunho:Estado {id: "estado-rascunho"})
SET rascunho.nome = "rascunho", rascunho.ordem = 1;

MERGE (conferencia:Estado {id: "estado-conferencia"})
SET conferencia.nome = "conferencia", conferencia.ordem = 2;

MERGE (confirmacao:Estado {id: "estado-confirmacao-lucas"})
SET confirmacao.nome = "confirmacao_lucas", confirmacao.ordem = 3;

MERGE (oficial:Estado {id: "estado-registro-oficial"})
SET oficial.nome = "registro_oficial", oficial.ordem = 4;

MERGE (conceitoTimer:Conceito {id: "conceito-timer"})
SET conceitoTimer.nome = "Timer", conceitoTimer.tipo = "metrica";

MERGE (conceitoTriagem:Conceito {id: "conceito-triagem"})
SET conceitoTriagem.nome = "Triagem", conceitoTriagem.tipo = "processo";

MERGE (conceitoClickUp:Conceito {id: "conceito-clickup-ready"})
SET conceitoClickUp.nome = "ClickUp Ready", conceitoClickUp.tipo = "integracao";

MERGE (leitura1:Leitura {id: "leitura-organizacao-tarefas-ficticia"})
SET
  leitura1.titulo = "Leitura ficticia sobre organizacao de tarefas",
  leitura1.status = "registro_oficial",
  leitura1.origem = "artigo publico ficticio",
  leitura1.clickup_ready = true;

MERGE (timerLeitura1:Timer {id: "timer-leitura-organizacao-tarefas-ficticia"})
SET
  timerLeitura1.duracao_minutos = 25,
  timerLeitura1.tipo = "tempo_gasto",
  timerLeitura1.evidencia = "sessao ficticia 09:00-09:25";

MERGE (tarefa1:Tarefa {id: "tarefa-testar-quadro-semanal-ficticia"})
SET
  tarefa1.titulo = "Testar quadro semanal ficticio",
  tarefa1.tipo = "execucao",
  tarefa1.status = "registro_oficial",
  tarefa1.prioridade = "media",
  tarefa1.clickup_ready = true;

MERGE (timerTarefa1:Timer {id: "timer-tarefa-testar-quadro-semanal-ficticia"})
SET
  timerTarefa1.duracao_minutos = 20,
  timerTarefa1.tipo = "tempo_gasto",
  timerTarefa1.evidencia = "execucao ficticia de 20 minutos";

MERGE (tarefaSemTimer:Tarefa {id: "tarefa-rascunho-sem-timer-ficticia"})
SET
  tarefaSemTimer.titulo = "Rascunho ficticio sem timer",
  tarefaSemTimer.tipo = "tarefa",
  tarefaSemTimer.status = "rascunho",
  tarefaSemTimer.prioridade = "baixa",
  tarefaSemTimer.clickup_ready = false;

MATCH (lab:Projeto {id: "projeto-segundo-cerebro-lab"})
MATCH (repo:Ferramenta {id: "ferramenta-github"})
MERGE (lab)-[:USA]->(repo);

MATCH (lab:Projeto {id: "projeto-segundo-cerebro-lab"})
MATCH (cli:Ferramenta {id: "ferramenta-cerebro-cli"})
MERGE (lab)-[:USA]->(cli);

MATCH (lab:Projeto {id: "projeto-segundo-cerebro-lab"})
MATCH (neo4j:Ferramenta {id: "ferramenta-neo4j"})
MERGE (lab)-[:USA]->(neo4j);

MATCH (lab:Projeto {id: "projeto-segundo-cerebro-lab"})
MATCH (clickup:Ferramenta {id: "ferramenta-clickup"})
MERGE (lab)-[:USA]->(clickup);

MATCH (lab:Projeto {id: "projeto-segundo-cerebro-lab"})
MATCH (triagem:Processo {id: "processo-triagem-com-timer"})
MERGE (lab)-[:DEFINE_ESCOPO]->(triagem);

MATCH (lab:Projeto {id: "projeto-segundo-cerebro-lab"})
MATCH (grafo:Processo {id: "processo-grafo-conhecimento"})
MERGE (lab)-[:DEFINE_ESCOPO]->(grafo);

MATCH (cli:Ferramenta {id: "ferramenta-cerebro-cli"})
MATCH (triagem:Processo {id: "processo-triagem-com-timer"})
MERGE (cli)-[:IMPLEMENTA]->(triagem);

MATCH (neo4j:Ferramenta {id: "ferramenta-neo4j"})
MATCH (grafo:Processo {id: "processo-grafo-conhecimento"})
MERGE (neo4j)-[:IMPLEMENTA]->(grafo);

MATCH (repo:Ferramenta {id: "ferramenta-github"})
MATCH (regraTimer:Regra {id: "regra-timer-obrigatorio"})
MERGE (repo)-[:VERSIONA]->(regraTimer);

MATCH (triagem:Processo {id: "processo-triagem-com-timer"})
MATCH (regraTimer:Regra {id: "regra-timer-obrigatorio"})
MERGE (triagem)-[:EXIGE]->(regraTimer);

MATCH (grafo:Processo {id: "processo-grafo-conhecimento"})
MATCH (regraTimer:Regra {id: "regra-timer-obrigatorio"})
MERGE (grafo)-[:EXIGE]->(regraTimer);

MATCH (regraTimer:Regra {id: "regra-timer-obrigatorio"})
MATCH (oficial:Estado {id: "estado-registro-oficial"})
MERGE (regraTimer)-[:CONDICIONA]->(oficial);

MATCH (rascunho:Estado {id: "estado-rascunho"})
MATCH (conferencia:Estado {id: "estado-conferencia"})
MERGE (rascunho)-[:CONECTA {tipo: "proximo_estado"}]->(conferencia);

MATCH (conferencia:Estado {id: "estado-conferencia"})
MATCH (confirmacao:Estado {id: "estado-confirmacao-lucas"})
MERGE (conferencia)-[:CONECTA {tipo: "proximo_estado"}]->(confirmacao);

MATCH (confirmacao:Estado {id: "estado-confirmacao-lucas"})
MATCH (oficial:Estado {id: "estado-registro-oficial"})
MERGE (confirmacao)-[:CONECTA {tipo: "proximo_estado"}]->(oficial);

MATCH (triagem:Processo {id: "processo-triagem-com-timer"})
MATCH (conceitoTriagem:Conceito {id: "conceito-triagem"})
MERGE (triagem)-[:CONECTA]->(conceitoTriagem);

MATCH (triagem:Processo {id: "processo-triagem-com-timer"})
MATCH (conceitoTimer:Conceito {id: "conceito-timer"})
MERGE (triagem)-[:CONECTA]->(conceitoTimer);

MATCH (triagem:Processo {id: "processo-triagem-com-timer"})
MATCH (conceitoClickUp:Conceito {id: "conceito-clickup-ready"})
MERGE (triagem)-[:CONECTA]->(conceitoClickUp);

MATCH (leitura1:Leitura {id: "leitura-organizacao-tarefas-ficticia"})
MATCH (timerLeitura1:Timer {id: "timer-leitura-organizacao-tarefas-ficticia"})
MERGE (leitura1)-[:TEM_TIMER]->(timerLeitura1);

MATCH (tarefa1:Tarefa {id: "tarefa-testar-quadro-semanal-ficticia"})
MATCH (timerTarefa1:Timer {id: "timer-tarefa-testar-quadro-semanal-ficticia"})
MERGE (tarefa1)-[:TEM_TIMER]->(timerTarefa1);

MATCH (leitura1:Leitura {id: "leitura-organizacao-tarefas-ficticia"})
MATCH (tarefa1:Tarefa {id: "tarefa-testar-quadro-semanal-ficticia"})
MERGE (leitura1)-[:GERA]->(tarefa1);

MATCH (leitura1:Leitura {id: "leitura-organizacao-tarefas-ficticia"})
MATCH (conceitoTriagem:Conceito {id: "conceito-triagem"})
MERGE (leitura1)-[:CONECTA]->(conceitoTriagem);

MATCH (tarefa1:Tarefa {id: "tarefa-testar-quadro-semanal-ficticia"})
MATCH (conceitoClickUp:Conceito {id: "conceito-clickup-ready"})
MERGE (tarefa1)-[:CONECTA]->(conceitoClickUp);

MATCH (tarefaSemTimer:Tarefa {id: "tarefa-rascunho-sem-timer-ficticia"})
MATCH (regraTimer:Regra {id: "regra-timer-obrigatorio"})
MERGE (tarefaSemTimer)-[:CONDICIONA]->(regraTimer);

MATCH (triagem:Processo {id: "processo-triagem-com-timer"})
MATCH (leitura1:Leitura {id: "leitura-organizacao-tarefas-ficticia"})
MERGE (triagem)-[:GERA]->(leitura1);

MATCH (triagem:Processo {id: "processo-triagem-com-timer"})
MATCH (tarefa1:Tarefa {id: "tarefa-testar-quadro-semanal-ficticia"})
MERGE (triagem)-[:GERA]->(tarefa1);

MATCH (triagem:Processo {id: "processo-triagem-com-timer"})
MATCH (tarefaSemTimer:Tarefa {id: "tarefa-rascunho-sem-timer-ficticia"})
MERGE (triagem)-[:GERA]->(tarefaSemTimer);
