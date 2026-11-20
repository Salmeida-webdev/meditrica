-- Expande o conjunto sintético para que os fluxos principais tenham exemplos variados.
-- Todos os registros permanecem no tenant de apresentação e usam contatos .invalid.
INSERT OR IGNORE INTO units(id,tenant_id,name,city,timezone,status) VALUES
('unit-norte','tenant-med-001','Unidade Norte','Campinas','America/Sao_Paulo','Ativo'),
('unit-sul','tenant-med-001','Unidade Sul','Santos','America/Sao_Paulo','Ativo');

INSERT OR IGNORE INTO patients(id,tenant_id,unit_id,code,full_name,phone,email,birth_date,source,status,notes) VALUES
('patient-007','tenant-med-001','unit-norte','PX-1007','Ana Martins','(00) 90000-1007','ana.martins@example.invalid','1988-04-12','Indicação','Ativo','Retorno previsto para o próximo mês.'),
('patient-008','tenant-med-001','unit-sul','PX-1008','Bruno Souza','(00) 90000-1008','bruno.souza@example.invalid','1979-09-03','Busca online','Ativo','Preferência de contato por e-mail.'),
('patient-009','tenant-med-001','unit-centro','PX-1009','Camila Rocha','(00) 90000-1009','camila.rocha@example.invalid','1995-02-20','Retorno','Retorno','Acompanhamento administrativo agendado.'),
('patient-010','tenant-med-001','unit-jardins','PX-1010','Diego Santos','(00) 90000-1010','diego.santos@example.invalid','1982-12-11','Indicação','Ativo','Cadastro completo para o fluxo de atendimento.'),
('patient-011','tenant-med-001','unit-norte','PX-1011','Elisa Almeida','(00) 90000-1011','elisa.almeida@example.invalid','1991-06-29','Busca online','Aguardando','Aguardando confirmação de horário.'),
('patient-012','tenant-med-001','unit-sul','PX-1012','Felipe Lima','(00) 90000-1012','felipe.lima@example.invalid','1974-01-17','Outros','Ativo','Cadastro de exemplo para o fluxo de retorno.'),
('patient-013','tenant-med-001','unit-centro','PX-1013','Gabriela Costa','(00) 90000-1013','gabriela.costa@example.invalid','1986-08-08','Indicação','Ativo','Preferência de contato registrada.'),
('patient-014','tenant-med-001','unit-jardins','PX-1014','Henrique Oliveira','(00) 90000-1014','henrique.oliveira@example.invalid','1998-03-25','Busca online','Inativo','Cadastro inativo para demonstrar filtros.'),
('patient-015','tenant-med-001','unit-norte','PX-1015','Isabela Ferreira','(00) 90000-1015','isabela.ferreira@example.invalid','1980-10-19','Retorno','Ativo','Retorno administrativo confirmado.'),
('patient-016','tenant-med-001','unit-sul','PX-1016','João Pedro Nunes','(00) 90000-1016','joao.nunes@example.invalid','1993-05-14','Indicação','Ativo','Cadastro de exemplo para a unidade Sul.'),
('patient-017','tenant-med-001','unit-centro','PX-1017','Larissa Ribeiro','(00) 90000-1017','larissa.ribeiro@example.invalid','1977-07-02','Outros','Aguardando','Aguardando retorno da recepção.'),
('patient-018','tenant-med-001','unit-jardins','PX-1018','Mateus Carvalho','(00) 90000-1018','mateus.carvalho@example.invalid','2000-11-26','Busca online','Ativo','Cadastro pronto para agendamento.');

INSERT OR IGNORE INTO professionals(id,tenant_id,unit_id,full_name,specialty,registration,phone,email,status) VALUES
('prof-005','tenant-med-001','unit-norte','Dra. Marina Alves','Fisioterapia','REG-1005','(00) 90000-2005','marina.alves@example.invalid','Ativo'),
('prof-006','tenant-med-001','unit-sul','Dr. Rafael Mendes','Nutrição','REG-1006','(00) 90000-2006','rafael.mendes@example.invalid','Ativo'),
('prof-007','tenant-med-001','unit-jardins','Dra. Paula Freitas','Psicologia','REG-1007','(00) 90000-2007','paula.freitas@example.invalid','Ativo'),
('prof-008','tenant-med-001','unit-centro','Dr. Tiago Barros','Clínica geral','REG-1008','(00) 90000-2008','tiago.barros@example.invalid','Ativo');

INSERT OR IGNORE INTO services(id,tenant_id,name,specialty,duration_minutes,price_cents,status) VALUES
('service-005','tenant-med-001','Sessão de fisioterapia','Fisioterapia',50,18000,'Ativo'),
('service-006','tenant-med-001','Avaliação nutricional','Nutrição',45,22000,'Ativo'),
('service-007','tenant-med-001','Consulta de acompanhamento','Psicologia',50,28000,'Ativo'),
('service-008','tenant-med-001','Consulta de retorno','Clínica geral',20,12000,'Ativo');

INSERT OR IGNORE INTO rooms(id,tenant_id,unit_id,name,resource_type,status) VALUES
('room-003','tenant-med-001','unit-norte','Sala de atendimento 03','Consultório','Ativo'),
('room-004','tenant-med-001','unit-sul','Sala de atendimento 04','Consultório','Ativo'),
('room-005','tenant-med-001','unit-centro','Sala de procedimentos 02','Sala de procedimentos','Ativo'),
('room-006','tenant-med-001','unit-jardins','Sala de avaliação 02','Sala de avaliação','Em manutenção');

INSERT OR IGNORE INTO appointments(id,tenant_id,unit_id,patient_id,professional_id,service_id,room_id,starts_at,ends_at,status,notes) VALUES
('appt-006','tenant-med-001','unit-norte','patient-007','prof-005','service-005','room-003','2026-11-20T14:30:00-03:00','2026-11-20T15:20:00-03:00','Confirmado','Confirmação registrada pela recepção.'),
('appt-007','tenant-med-001','unit-sul','patient-008','prof-006','service-006','room-004','2026-11-20T15:00:00-03:00','2026-11-20T15:45:00-03:00','A confirmar','Aguardando resposta de confirmação.'),
('appt-008','tenant-med-001','unit-centro','patient-009','prof-002','service-008','room-001','2026-11-20T16:00:00-03:00','2026-11-20T16:20:00-03:00','Em recepção','Check-in iniciado na recepção.'),
('appt-009','tenant-med-001','unit-jardins','patient-010','prof-007','service-007','room-002','2026-11-20T16:15:00-03:00','2026-11-20T17:05:00-03:00','Em atendimento','Atendimento em andamento.'),
('appt-010','tenant-med-001','unit-norte','patient-011','prof-005','service-005','room-003','2026-11-21T08:00:00-03:00','2026-11-21T08:50:00-03:00','Agendado','Lembrete programado para o dia anterior.'),
('appt-011','tenant-med-001','unit-sul','patient-012','prof-006','service-006','room-004','2026-11-21T09:00:00-03:00','2026-11-21T09:45:00-03:00','Confirmado','Confirmação recebida.'),
('appt-012','tenant-med-001','unit-centro','patient-013','prof-008','service-001','room-005','2026-11-21T10:30:00-03:00','2026-11-21T11:00:00-03:00','Concluído','Atendimento encerrado no fluxo de exemplo.'),
('appt-013','tenant-med-001','unit-jardins','patient-014','prof-003','service-004','room-002','2026-11-21T11:00:00-03:00','2026-11-21T11:30:00-03:00','Falta','Falta registrada para demonstrar acompanhamento.'),
('appt-014','tenant-med-001','unit-norte','patient-015','prof-005','service-005','room-003','2026-11-22T08:30:00-03:00','2026-11-22T09:20:00-03:00','Confirmado','Retorno confirmado.'),
('appt-015','tenant-med-001','unit-sul','patient-016','prof-006','service-006','room-004','2026-11-22T10:00:00-03:00','2026-11-22T10:45:00-03:00','Cancelado','Cancelamento registrado no histórico.'),
('appt-016','tenant-med-001','unit-centro','patient-017','prof-008','service-008','room-001','2026-11-23T13:00:00-03:00','2026-11-23T13:20:00-03:00','A confirmar','Contato de confirmação pendente.'),
('appt-017','tenant-med-001','unit-jardins','patient-018','prof-007','service-007','room-002','2026-11-23T14:00:00-03:00','2026-11-23T14:50:00-03:00','Agendado','Agendamento incluído pela recepção.'),
('appt-018','tenant-med-001','unit-norte','patient-008','prof-005','service-005','room-003','2026-11-24T09:00:00-03:00','2026-11-24T09:50:00-03:00','Confirmado','Retorno confirmado por e-mail.'),
('appt-019','tenant-med-001','unit-sul','patient-010','prof-006','service-006','room-004','2026-11-24T10:30:00-03:00','2026-11-24T11:15:00-03:00','Agendado','Lembrete a enviar no dia anterior.'),
('appt-020','tenant-med-001','unit-centro','patient-012','prof-002','service-002','room-001','2026-11-25T11:00:00-03:00','2026-11-25T11:20:00-03:00','Confirmado','Retorno incluído no calendário.');

INSERT OR IGNORE INTO clinical_records(id,tenant_id,unit_id,patient_id,appointment_id,professional_id,record_type,summary,status,author_id) VALUES
('record-003','tenant-med-001','unit-norte','patient-007','appt-006','prof-005','Evolução','Registro estrutural sem conteúdo assistencial.','Concluído','user-owner-demo'),
('record-004','tenant-med-001','unit-sul','patient-008','appt-007','prof-006','Triagem','Campos de exemplo sem informação clínica.','Revisão','user-owner-demo'),
('record-005','tenant-med-001','unit-centro','patient-009','appt-008','prof-002','Anamnese','Estrutura de anamnese sem dados clínicos.','Rascunho','user-owner-demo'),
('record-006','tenant-med-001','unit-jardins','patient-010','appt-009','prof-007','Evolução','Registro de acompanhamento sem conteúdo clínico.','Concluído','user-owner-demo'),
('record-007','tenant-med-001','unit-norte','patient-011','appt-010','prof-005','Triagem','Campos preparados para revisão de fluxo.','Revisão','user-owner-demo'),
('record-008','tenant-med-001','unit-sul','patient-012','appt-011','prof-006','Evolução','Registro de exemplo sem informação assistencial.','Rascunho','user-owner-demo'),
('record-009','tenant-med-001','unit-centro','patient-013','appt-012','prof-008','Evolução','Registro administrativo encerrado.','Concluído','user-owner-demo'),
('record-010','tenant-med-001','unit-jardins','patient-018','appt-017','prof-007','Anamnese','Estrutura de registro sem conteúdo clínico.','Rascunho','user-owner-demo');

INSERT OR IGNORE INTO documents(id,tenant_id,unit_id,patient_id,appointment_id,professional_id,document_type,title,status,issued_at) VALUES
('doc-003','tenant-med-001','unit-norte','patient-007','appt-006','prof-005','Modelo de declaração','Declaração de comparecimento — rascunho','Rascunho',NULL),
('doc-004','tenant-med-001','unit-sul','patient-008','appt-007','prof-006','Modelo de encaminhamento','Encaminhamento — revisão interna','Revisão',NULL),
('doc-005','tenant-med-001','unit-centro','patient-009','appt-008','prof-002','Termo','Termo de consentimento — modelo','Rascunho',NULL),
('doc-006','tenant-med-001','unit-jardins','patient-010','appt-009','prof-007','Modelo de solicitação de exame','Solicitação de exame — rascunho','Rascunho',NULL),
('doc-007','tenant-med-001','unit-norte','patient-011','appt-010','prof-005','Modelo de declaração','Declaração de comparecimento — revisão','Revisão',NULL),
('doc-008','tenant-med-001','unit-sul','patient-012','appt-011','prof-006','Termo','Termo de atendimento — modelo','Rascunho',NULL),
('doc-009','tenant-med-001','unit-centro','patient-013','appt-012','prof-008','Modelo de encaminhamento','Encaminhamento — exemplo de fluxo','Rascunho',NULL),
('doc-010','tenant-med-001','unit-jardins','patient-018','appt-017','prof-007','Modelo de declaração','Declaração — revisão interna','Revisão',NULL);

INSERT OR IGNORE INTO payments(id,tenant_id,unit_id,patient_id,description,amount_cents,method,status,due_date,settled_at) VALUES
('pay-005','tenant-med-001','unit-norte','patient-007','Sessão de fisioterapia',18000,'Pix','Recebido','2026-11-20','2026-11-20'),
('pay-006','tenant-med-001','unit-sul','patient-008','Avaliação nutricional',22000,'Cartão','Em aberto','2026-11-21',NULL),
('pay-007','tenant-med-001','unit-centro','patient-009','Consulta de retorno',12000,'Dinheiro','Recebido','2026-11-20','2026-11-20'),
('pay-008','tenant-med-001','unit-jardins','patient-010','Consulta de acompanhamento',28000,'Convênio','Em aberto','2026-11-25',NULL),
('pay-009','tenant-med-001','unit-norte','patient-011','Sessão de fisioterapia',18000,'Pix','Estornado','2026-11-19','2026-11-19'),
('pay-010','tenant-med-001','unit-sul','patient-012','Avaliação nutricional',22000,'Cartão','Recebido','2026-11-21','2026-11-21'),
('pay-011','tenant-med-001','unit-centro','patient-013','Consulta de clínica geral',25000,'Pix','Em aberto','2026-11-22',NULL),
('pay-012','tenant-med-001','unit-jardins','patient-018','Consulta de acompanhamento',28000,'Cartão','Recebido','2026-11-23','2026-11-23');

INSERT OR IGNORE INTO expenses(id,tenant_id,unit_id,description,category,amount_cents,status,due_date,settled_at) VALUES
('expense-004','tenant-med-001','unit-norte','Materiais de atendimento','Materiais',74800,'Pago','2026-11-18','2026-11-18'),
('expense-005','tenant-med-001','unit-sul','Serviço de limpeza','Operacional',165000,'A pagar','2026-11-24',NULL),
('expense-006','tenant-med-001','unit-centro','Manutenção de equipamentos','Manutenção',230000,'A pagar','2026-11-26',NULL),
('expense-007','tenant-med-001','unit-jardins','Energia e utilidades','Operacional',94200,'Pago','2026-11-17','2026-11-17'),
('expense-008','tenant-med-001','unit-norte','Material de escritório','Materiais',38100,'A pagar','2026-11-28',NULL),
('expense-009','tenant-med-001','unit-sul','Licença de software','Tecnologia',12900,'Vencido','2026-11-19',NULL),
('expense-010','tenant-med-001','unit-centro','Reposição de itens de apoio','Materiais',56700,'Pago','2026-11-20','2026-11-20');

INSERT OR IGNORE INTO insurance_plans(id,tenant_id,name,registration_code,contact,status) VALUES
('plan-004','tenant-med-001','Vida Plena','PL-2004','credenciamento@example.invalid','Ativo'),
('plan-005','tenant-med-001','Bem Cuidar','PL-2005','rede@example.invalid','Ativo'),
('plan-006','tenant-med-001','Saúde Horizonte','PL-2006','relacionamento@example.invalid','Em configuração');

INSERT OR IGNORE INTO insurance_claims(id,tenant_id,unit_id,plan_id,patient_id,reference_code,amount_cents,status,submitted_at) VALUES
('claim-004','tenant-med-001','unit-norte','plan-004','patient-007','GUIA-2004',18000,'Autorizada','2026-11-19'),
('claim-005','tenant-med-001','unit-sul','plan-005','patient-008','GUIA-2005',22000,'Em análise','2026-11-20'),
('claim-006','tenant-med-001','unit-centro','plan-001','patient-009','GUIA-2006',12000,'Enviada','2026-11-20'),
('claim-007','tenant-med-001','unit-jardins','plan-002','patient-010','GUIA-2007',28000,'Glosa em recurso','2026-11-18'),
('claim-008','tenant-med-001','unit-norte','plan-004','patient-011','GUIA-2008',18000,'Em análise','2026-11-20'),
('claim-009','tenant-med-001','unit-sul','plan-005','patient-012','GUIA-2009',22000,'Autorizada','2026-11-17'),
('claim-010','tenant-med-001','unit-centro','plan-006','patient-013','GUIA-2010',25000,'Enviada','2026-11-20');

INSERT OR IGNORE INTO inventory_items(id,tenant_id,unit_id,code,name,category,quantity,minimum_quantity,unit_label,lot,expires_on,status) VALUES
('item-005','tenant-med-001','unit-norte','MAT-205','Luvas de procedimento','Material',42,20,'caixas','L-205-A','2027-07-30','Ativo'),
('item-006','tenant-med-001','unit-sul','MAT-206','Máscara cirúrgica','Material',18,25,'caixas','L-206-B','2027-09-30','Reposição'),
('item-007','tenant-med-001','unit-centro','MAT-207','Gaze estéril','Material',36,15,'pacotes','L-207-C','2027-05-31','Ativo'),
('item-008','tenant-med-001','unit-jardins','MAT-208','Solução antisséptica','Material',9,12,'unidades','L-208-D','2027-04-30','Reposição'),
('item-009','tenant-med-001','unit-norte','MAT-209','Papel para maca','Descartáveis',24,10,'rolos','L-209-A','2028-01-31','Ativo'),
('item-010','tenant-med-001','unit-sul','MAT-210','Touca descartável','Descartáveis',14,20,'pacotes','L-210-B','2027-12-31','Reposição'),
('item-011','tenant-med-001','unit-centro','MAT-211','Álcool 70%','Higiene',8,8,'frascos','L-211-C','2027-08-31','Ativo'),
('item-012','tenant-med-001','unit-jardins','MAT-212','Luva para procedimento','Material',0,10,'caixas','L-212-D','2027-10-31','Reposição');

INSERT OR IGNORE INTO suppliers(id,tenant_id,name,contact,email,status) VALUES
('supplier-003','tenant-med-001','Distribuidora Central','(00) 90000-3003','pedidos.central@example.invalid','Ativo'),
('supplier-004','tenant-med-001','Suprimentos Horizonte','(00) 90000-3004','comercial.horizonte@example.invalid','Ativo'),
('supplier-005','tenant-med-001','Apoio Clínico Sul','(00) 90000-3005','contato.sul@example.invalid','Ativo'),
('supplier-006','tenant-med-001','Serviços Integrados Norte','(00) 90000-3006','atendimento.norte@example.invalid','Inativo');

INSERT OR IGNORE INTO communications(id,tenant_id,unit_id,patient_id,channel,subject,status,scheduled_at,consent_status) VALUES
('comm-003','tenant-med-001','unit-norte','patient-007','E-mail','Confirmação de atendimento','Enviada','2026-11-20T08:00:00-03:00','Registrado'),
('comm-004','tenant-med-001','unit-sul','patient-008','SMS','Lembrete de horário','Programada','2026-11-20T14:00:00-03:00','Registrado'),
('comm-005','tenant-med-001','unit-centro','patient-009','WhatsApp','Orientação de chegada','Enviada','2026-11-20T12:30:00-03:00','Registrado'),
('comm-006','tenant-med-001','unit-jardins','patient-010','E-mail','Retorno de acompanhamento','Programada','2026-11-21T08:00:00-03:00','Registrado'),
('comm-007','tenant-med-001','unit-norte','patient-011','SMS','Confirmação pendente','Aguardando resposta','2026-11-20T13:00:00-03:00','Registrado'),
('comm-008','tenant-med-001','unit-sul','patient-012','E-mail','Recibo disponível','Enviada','2026-11-21T10:00:00-03:00','Registrado'),
('comm-009','tenant-med-001','unit-centro','patient-013','WhatsApp','Pesquisa de satisfação','Programada','2026-11-22T09:00:00-03:00','Registrado'),
('comm-010','tenant-med-001','unit-jardins','patient-018','SMS','Lembrete de consulta','Programada','2026-11-22T12:00:00-03:00','Registrado');

INSERT OR IGNORE INTO tasks(id,tenant_id,unit_id,title,category,assigned_to,due_at,status,priority) VALUES
('task-004','tenant-med-001','unit-norte','Confirmar agenda da manhã','Recepção','Equipe Centro','2026-11-20T15:00:00-03:00','Pendente','Alta'),
('task-005','tenant-med-001','unit-sul','Conferir materiais recebidos','Estoque','Equipe Sul','2026-11-21T11:00:00-03:00','Em andamento','Normal'),
('task-006','tenant-med-001','unit-centro','Revisar guias em análise','Faturamento','Equipe Financeira','2026-11-21T16:00:00-03:00','Pendente','Alta'),
('task-007','tenant-med-001','unit-jardins','Atualizar cadastro de fornecedor','Administrativo','Equipe Clínica','2026-11-22T12:00:00-03:00','Concluída','Baixa'),
('task-008','tenant-med-001','unit-norte','Preparar sala de atendimento','Operação','Equipe Norte','2026-11-21T07:30:00-03:00','Pendente','Normal'),
('task-009','tenant-med-001','unit-sul','Enviar lembretes de consulta','Relacionamento','Recepção Sul','2026-11-20T16:30:00-03:00','Em andamento','Normal'),
('task-010','tenant-med-001','unit-centro','Conferir despesas do período','Financeiro','Equipe Financeira','2026-11-24T17:00:00-03:00','Pendente','Baixa'),
('task-011','tenant-med-001','unit-jardins','Acompanhar retorno de convênio','Faturamento','Equipe Jardins','2026-11-23T15:00:00-03:00','Pendente','Alta'),
('task-012','tenant-med-001','unit-norte','Revisar disponibilidade de salas','Operação','Equipe Norte','2026-11-22T10:00:00-03:00','Concluída','Normal');

UPDATE platform_subscriptions SET plan_name='Medítrica Essencial',status='Ativo' WHERE id='subscription-demo';
