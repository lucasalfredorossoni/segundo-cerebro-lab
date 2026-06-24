# Protocolo de Triagem com Timer Obrigatorio

## Objetivo

Garantir que todo registro de tarefa, leitura ou execucao tenha uma metrica de
tempo antes de entrar no sistema oficial do Segundo Cerebro Lab.

Este protocolo evita registros soltos, melhora auditoria operacional e deixa a
estrutura pronta para integracao futura com ClickUp.

## Regra central

Nenhum registro vira oficial sem timer ou metrica de tempo.

Se o tempo nao foi informado, o item continua como rascunho. O assistente pode
organizar o conteudo, mas nao pode promover o registro.

## Escopo

Este protocolo se aplica a:

- tarefas;
- leituras;
- execucoes;
- revisoes operacionais;
- estudos que gerem acao ou registro.

## Fluxo obrigatorio

1. Rascunho

   A entrada bruta e transformada em item estruturado. Nesta fase, dados
   incompletos sao permitidos, mas o item deve declarar se possui timer.

2. Conferencia

   O item e revisado quanto a tempo, clareza, sensibilidade dos dados e
   prontidao para registro.

3. Confirmacao do Lucas

   O Lucas precisa confirmar explicitamente que o item pode virar oficial. Sem
   essa confirmacao, o item permanece em conferencia ou rascunho.

4. Registro oficial

   Apenas itens com timer valido, sem dados sensiveis e confirmados pelo Lucas
   podem entrar no registro oficial.

## Timer e metricas aceitas

Um item precisa ter pelo menos uma metrica de tempo:

- horario de inicio e fim;
- duracao total em minutos;
- tempo estimado em minutos;
- tempo gasto em minutos;
- janela de execucao;
- sessao de leitura com duracao registrada.

Para leituras, podem ser adicionadas metricas auxiliares:

- paginas lidas;
- capitulos lidos;
- percentual concluido;
- minutos por sessao.

Metricas auxiliares nao substituem o tempo. Elas apenas enriquecem o registro.

## Criterios para oficializar

Um item pode virar oficial somente quando todos os criterios abaixo forem
verdadeiros:

- possui timer ou metrica de tempo valida;
- passou pela conferencia;
- nao contem dados pessoais reais;
- nao contem dados clinicos;
- nao contem senhas, tokens ou credenciais;
- nao contem exports privados;
- recebeu confirmacao explicita do Lucas;
- tem titulo e descricao suficientes para recuperacao futura.

## Bloqueios

Use estes estados quando o item nao puder avancar:

- `bloqueado_por_timer`: falta timer ou metrica de tempo.
- `pendente_confirmacao_lucas`: falta confirmacao explicita.
- `dados_sensiveis`: contem informacao que nao deve ser registrada.
- `incompleto`: falta contexto minimo para entender o item.

## Campos minimos

Todo rascunho deve tentar preencher:

- tipo: tarefa, leitura ou execucao;
- titulo;
- descricao;
- origem;
- fase;
- timer ou motivo de bloqueio;
- prioridade;
- perguntas pendentes;
- status de confirmacao do Lucas.

## Preparacao para ClickUp

Os registros devem ser estruturados para futura criacao de tarefas no ClickUp.
Quando a integracao existir, os campos abaixo podem ser mapeados:

- titulo -> nome da tarefa;
- descricao -> descricao da tarefa;
- prioridade -> prioridade;
- tempo estimado -> time estimate;
- tempo gasto -> time tracked;
- fase -> status ou custom field;
- origem -> custom field;
- confirmacao do Lucas -> custom field booleano;
- motivo de bloqueio -> tag ou custom field.

Itens bloqueados nao devem ser enviados como tarefa oficial. Eles podem ser
enviados futuramente para uma lista de triagem, desde que fiquem marcados como
rascunho e sem status oficial.

## Seguranca de dados

Nao registre:

- dados pessoais reais;
- dados clinicos;
- senhas;
- tokens;
- chaves de API;
- exports privados;
- conversas privadas sem autorizacao;
- anexos contendo informacao sensivel.

Quando houver duvida, mantenha o item como rascunho e solicite uma versao segura.

## Exemplo de decisao

- Entrada com tarefa e duracao de 25 minutos: pode seguir para conferencia.
- Entrada com leitura sem duracao: fica bloqueada por timer.
- Entrada com token ou dado privado: fica bloqueada por dado sensivel.
- Entrada com timer e conteudo seguro: aguarda confirmacao do Lucas antes do
  registro oficial.
