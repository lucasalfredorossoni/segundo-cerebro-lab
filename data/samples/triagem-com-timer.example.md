# Exemplo Seguro - Triagem com Timer

Este exemplo e ficticio. Nao contem dados pessoais reais, dados clinicos,
senhas, tokens ou exports privados.

## Entrada bruta ficticia

```text
Li um artigo publico sobre organizacao de tarefas e separei uma acao para testar
um quadro semanal. Sessao de leitura das 09:00 as 09:25. Depois executei um
rascunho do quadro por 20 minutos. Prioridade media.
```

## Rascunho estruturado

### Status

- fase: rascunho
- pode_virar_oficial: sim
- motivo_bloqueio: nenhum

### Item 1

- tipo: leitura
- titulo: Leitura sobre organizacao de tarefas
- descricao: Leitura de artigo publico para coletar ideias sobre organizacao de
  tarefas semanais.
- origem: anotacao manual ficticia
- prioridade: media

### Timer

- timer_inicio: 09:00
- timer_fim: 09:25
- duracao_minutos: 25
- tempo_estimado_minutos:
- tempo_gasto_minutos: 25
- janela_de_execucao: manha
- evidencia_do_timer: entrada bruta informou sessao das 09:00 as 09:25

### Conferencia

- dados_sensiveis_detectados: nao
- ajustes_necessarios: confirmar se o artigo publico deve ser referenciado pelo
  link ou apenas pelo tema.
- perguntas_para_lucas: "Pode registrar esta leitura como oficial?"

### Confirmacao do Lucas

- confirmado_por_lucas: nao
- confirmado_em:
- observacao: aguardando confirmacao.

### Registro Oficial

- registrar_agora: nao
- motivo: pendente_confirmacao_lucas
- resumo_oficial_proposto: Leitura publica sobre organizacao de tarefas, com
  duracao de 25 minutos, usada para gerar acao de teste de quadro semanal.

### Preparacao ClickUp

- clickup_ready: sim
- clickup_task_name: Testar quadro semanal de tarefas
- clickup_description: Criar um rascunho de quadro semanal com base na leitura
  publica sobre organizacao de tarefas.
- clickup_time_estimate_minutes: 20
- clickup_time_spent_minutes: 25
- clickup_tags: triagem, leitura, timer
- clickup_custom_fields:
  - fase_triagem: rascunho
  - timer_obrigatorio: true
  - confirmado_por_lucas: false

## Item 2

- tipo: execucao
- titulo: Rascunho de quadro semanal
- descricao: Criacao de um primeiro rascunho de quadro semanal para testar uma
  rotina de organizacao.
- origem: acao derivada da leitura ficticia
- prioridade: media

### Timer

- timer_inicio:
- timer_fim:
- duracao_minutos: 20
- tempo_estimado_minutos: 20
- tempo_gasto_minutos: 20
- janela_de_execucao: apos leitura
- evidencia_do_timer: entrada bruta informou execucao por 20 minutos

### Conferencia

- dados_sensiveis_detectados: nao
- ajustes_necessarios: validar se o rascunho deve virar tarefa no ClickUp.
- perguntas_para_lucas: "Confirmo este rascunho como execucao oficial?"

### Confirmacao do Lucas

- confirmado_por_lucas: nao
- confirmado_em:
- observacao: aguardando confirmacao.

### Registro Oficial

- registrar_agora: nao
- motivo: pendente_confirmacao_lucas
- resumo_oficial_proposto: Execucao ficticia de 20 minutos para criar um
  rascunho de quadro semanal.

### Preparacao ClickUp

- clickup_ready: sim
- clickup_task_name: Revisar rascunho de quadro semanal
- clickup_description: Revisar o rascunho criado em sessao ficticia de 20
  minutos e decidir se vira rotina operacional.
- clickup_time_estimate_minutes: 20
- clickup_time_spent_minutes: 20
- clickup_tags: triagem, execucao, timer
- clickup_custom_fields:
  - fase_triagem: rascunho
  - timer_obrigatorio: true
  - confirmado_por_lucas: false

## Observacao

Mesmo com timer valido, nenhum dos itens vira oficial antes da confirmacao
explicita do Lucas.
