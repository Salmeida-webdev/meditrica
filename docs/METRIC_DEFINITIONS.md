# Contrato inicial de indicadores — Medítrica

Versão inicial de produto. Os números da demonstração são sintéticos; este contrato define como os indicadores deverão ser calculados, sujeitos à validação com clínicas-piloto.

## Regras comuns

- Todo relatório deve indicar período, unidade, fuso horário e data/hora da última atualização.
- O padrão de período é a data local da unidade. Datas futuras não entram em métricas de execução.
- Cancelamentos, reagendamentos, estornos e registros arquivados devem ser tratados explicitamente, sem apagar o histórico.
- Cada cartão e gráfico deve permitir consultar a definição, filtros e origem do dado.
- Totais financeiros devem indicar claramente caixa (liquidado) ou competência (reconhecido). Não misturar bases.

## Indicadores

| Indicador | Definição inicial | Fonte esperada |
|---|---|---|
| Consultas agendadas | Quantidade de horários válidos cuja data de início está no período, excluindo eventos cancelados antes do atendimento. | Agenda |
| Taxa de confirmação | Agendamentos confirmados ÷ agendamentos que exigem confirmação no período. Exibir como não aplicável se o denominador for zero. | Agenda e histórico de confirmação |
| Taxa de comparecimento | Atendimentos com check-in/realização ÷ agendamentos elegíveis já ocorridos; excluir cancelamentos antecipados e consultas futuras. | Agenda e recepção |
| Taxa de faltas | Agendamentos marcados como falta ÷ agendamentos elegíveis já ocorridos. Faltas e cancelamentos tardios permanecem distinguíveis. | Agenda e recepção |
| Ocupação de agenda | Minutos reservados em horários oferecidos ÷ minutos disponíveis para atendimento após bloqueios, feriados e pausas configuradas. Reencaixes não podem contar duas vezes. | Agenda, profissionais, salas e horários |
| Prazo médio para consulta | Média de dias corridos entre criação do agendamento e a data/hora marcada, limitada aos agendamentos válidos criados no período. Mostrar mediana junto à média quando a amostra permitir. | Histórico de agenda |
| Novos pacientes | Pessoas com primeiro atendimento realizado no período; cadastro sem atendimento não conta como novo paciente atendido. | Pacientes e atendimentos |
| Receita recebida líquida | Pagamentos liquidados no período menos estornos/reembolsos liquidados no mesmo período; sempre indicar base de caixa. | Financeiro |
| Valores a receber vencidos | Títulos em aberto com vencimento anterior à data local de corte, líquidos de baixas e estornos registrados. | Contas a receber |
| Produção por profissional | Atendimentos realizados no período, associados ao profissional responsável no registro, com regras de transferência documentadas. | Agenda e atendimento |

## Comparações e qualidade

- Comparações usam a mesma duração e granularidade; feriados e períodos incompletos devem ser destacados.
- Mudanças de unidade, fuso, status ou regra de cálculo ficam versionadas.
- Valores sem fonte reconciliada são rotulados como estimativas; nunca apresentados como dado contábil fechado.
- Exportações respeitam as permissões e registram usuário, filtros e data/hora.
- Nenhuma métrica clínica de qualidade assistencial será criada sem validação com responsáveis clínicos e finalidade definida.
