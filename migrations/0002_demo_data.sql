INSERT OR IGNORE INTO tenants(id,name,plan,status,is_demo) VALUES('tenant-med-001','Clínica Modelo Medítrica','Demonstração','active',1);
INSERT OR IGNORE INTO units(id,tenant_id,name,city,timezone,status) VALUES
('unit-centro','tenant-med-001','Unidade Centro','São Paulo (fictícia)','America/Sao_Paulo','Ativo'),
('unit-jardins','tenant-med-001','Unidade Jardins','São Paulo (fictícia)','America/Sao_Paulo','Ativo');
INSERT OR IGNORE INTO patients(id,tenant_id,unit_id,code,full_name,phone,email,birth_date,source,status,notes) VALUES
('patient-001','tenant-med-001','unit-centro','PX-DEMO-001','Pessoa Fictícia 01','(00) 90000-0001','pessoa01@example.invalid','1989-03-14','Indicação','Ativo','Cadastro sintético para demonstração.'),
('patient-002','tenant-med-001','unit-centro','PX-DEMO-002','Pessoa Fictícia 02','(00) 90000-0002','pessoa02@example.invalid','1976-08-22','Busca online','Ativo','Cadastro sintético para demonstração.'),
('patient-003','tenant-med-001','unit-jardins','PX-DEMO-003','Pessoa Fictícia 03','(00) 90000-0003','pessoa03@example.invalid','1994-11-05','Retorno','Retorno','Cadastro sintético para demonstração.'),
('patient-004','tenant-med-001','unit-centro','PX-DEMO-004','Pessoa Fictícia 04','(00) 90000-0004','pessoa04@example.invalid','1983-01-30','Indicação','Ativo','Cadastro sintético para demonstração.'),
('patient-005','tenant-med-001','unit-jardins','PX-DEMO-005','Pessoa Fictícia 05','(00) 90000-0005','pessoa05@example.invalid','2001-06-18','Outros','Aguardando','Cadastro sintético para demonstração.'),
('patient-006','tenant-med-001','unit-centro','PX-DEMO-006','Pessoa Fictícia 06','(00) 90000-0006','pessoa06@example.invalid','1990-12-09','Busca online','Ativo','Cadastro sintético para demonstração.');
INSERT OR IGNORE INTO professionals(id,tenant_id,unit_id,full_name,specialty,registration,phone,email,status) VALUES
('prof-001','tenant-med-001','unit-centro','Dr. Caio Exemplo','Cardiologia','CRM-DEMO-001','(00) 90000-0011','caio@example.invalid','Ativo'),
('prof-002','tenant-med-001','unit-centro','Dra. Bia Exemplo','Clínica geral','CRM-DEMO-002','(00) 90000-0012','bia@example.invalid','Ativo'),
('prof-003','tenant-med-001','unit-jardins','Dra. Lia Exemplo','Dermatologia','CRM-DEMO-003','(00) 90000-0013','lia@example.invalid','Ativo'),
('prof-004','tenant-med-001','unit-centro','Dr. Nilo Exemplo','Ortopedia','CRM-DEMO-004','(00) 90000-0014','nilo@example.invalid','Ativo');
INSERT OR IGNORE INTO services(id,tenant_id,name,specialty,duration_minutes,price_cents,status) VALUES
('service-001','tenant-med-001','Consulta demonstrativa','Clínica geral',30,25000,'Ativo'),('service-002','tenant-med-001','Retorno demonstrativo','Clínica geral',20,0,'Ativo'),('service-003','tenant-med-001','Avaliação demonstrativa','Cardiologia',45,42000,'Ativo'),('service-004','tenant-med-001','Consulta demonstrativa','Dermatologia',30,35000,'Ativo');
INSERT OR IGNORE INTO rooms(id,tenant_id,unit_id,name,resource_type,status) VALUES('room-001','tenant-med-001','unit-centro','Consultório 01','Consultório','Ativo'),('room-002','tenant-med-001','unit-jardins','Consultório 02','Consultório','Ativo');
INSERT OR IGNORE INTO appointments(id,tenant_id,unit_id,patient_id,professional_id,service_id,room_id,starts_at,ends_at,status,notes) VALUES
('appt-001','tenant-med-001','unit-centro','patient-001','prof-001','service-003','room-001','2026-11-20T08:30:00-03:00','2026-11-20T09:15:00-03:00','Confirmado','Agenda fictícia demonstrativa.'),
('appt-002','tenant-med-001','unit-centro','patient-002','prof-002','service-001','room-001','2026-11-20T09:15:00-03:00','2026-11-20T09:45:00-03:00','Confirmado','Agenda fictícia demonstrativa.'),
('appt-003','tenant-med-001','unit-jardins','patient-003','prof-003','service-004','room-002','2026-11-20T10:00:00-03:00','2026-11-20T10:30:00-03:00','A confirmar','Agenda fictícia demonstrativa.'),
('appt-004','tenant-med-001','unit-centro','patient-004','prof-004','service-001','room-001','2026-11-20T10:45:00-03:00','2026-11-20T11:15:00-03:00','Em recepção','Agenda fictícia demonstrativa.'),
('appt-005','tenant-med-001','unit-centro','patient-005','prof-002','service-002','room-001','2026-11-21T13:30:00-03:00','2026-11-21T13:50:00-03:00','Agendado','Agenda fictícia demonstrativa.');
INSERT OR IGNORE INTO clinical_records(id,tenant_id,unit_id,patient_id,appointment_id,professional_id,record_type,summary,status,author_id) VALUES
('record-001','tenant-med-001','unit-centro','patient-001','appt-001','prof-001','Evolução demonstrativa','Registro sintético sem conteúdo assistencial.','Rascunho','user-owner-demo'),
('record-002','tenant-med-001','unit-centro','patient-002','appt-002','prof-002','Triagem demonstrativa','Registro sintético sem conteúdo assistencial.','Concluído','user-owner-demo');
INSERT OR IGNORE INTO documents(id,tenant_id,unit_id,patient_id,appointment_id,professional_id,document_type,title,status,issued_at) VALUES
('doc-001','tenant-med-001','unit-centro','patient-001','appt-001','prof-001','Modelo de declaração','Declaração fictícia (rascunho)','Rascunho',NULL),
('doc-002','tenant-med-001','unit-jardins','patient-003','appt-003','prof-003','Modelo de encaminhamento','Encaminhamento fictício (rascunho)','Rascunho',NULL);
INSERT OR IGNORE INTO payments(id,tenant_id,unit_id,patient_id,description,amount_cents,method,status,due_date,settled_at) VALUES
('pay-001','tenant-med-001','unit-centro','patient-001','Consulta demonstrativa',42000,'Pix','Recebido','2026-11-20','2026-11-20'),
('pay-002','tenant-med-001','unit-centro','patient-002','Consulta demonstrativa',25000,'Cartão','Recebido','2026-11-20','2026-11-20'),
('pay-003','tenant-med-001','unit-jardins','patient-003','Consulta demonstrativa',35000,'Convênio','Em aberto','2026-11-25',NULL),
('pay-004','tenant-med-001','unit-centro','patient-004','Consulta demonstrativa',25000,'Pix','Recebido','2026-11-19','2026-11-19');
INSERT OR IGNORE INTO expenses(id,tenant_id,unit_id,description,category,amount_cents,status,due_date,settled_at) VALUES
('expense-001','tenant-med-001','unit-centro','Material de consumo (fictício)','Materiais',86000,'Pago','2026-11-18','2026-11-18'),
('expense-002','tenant-med-001','unit-jardins','Serviços e utilidades (fictício)','Operacional',124000,'A pagar','2026-11-25',NULL),
('expense-003','tenant-med-001','unit-centro','Manutenção programada (fictícia)','Manutenção',62000,'A pagar','2026-11-28',NULL);
INSERT OR IGNORE INTO insurance_plans(id,tenant_id,name,registration_code,contact,status) VALUES
('plan-001','tenant-med-001','Plano Horizonte (demo)','PLANO-DEMO-001','contato@example.invalid','Ativo'),
('plan-002','tenant-med-001','Saúde Integral (demo)','PLANO-DEMO-002','atendimento@example.invalid','Ativo'),
('plan-003','tenant-med-001','Rede Bem-Estar (demo)','PLANO-DEMO-003','rede@example.invalid','Em configuração');
INSERT OR IGNORE INTO insurance_claims(id,tenant_id,unit_id,plan_id,patient_id,reference_code,amount_cents,status,submitted_at) VALUES
('claim-001','tenant-med-001','unit-centro','plan-001','patient-001','GUIA-DEMO-1001',42000,'Em análise','2026-11-18'),
('claim-002','tenant-med-001','unit-jardins','plan-002','patient-003','GUIA-DEMO-1002',35000,'Enviada','2026-11-19'),
('claim-003','tenant-med-001','unit-centro','plan-001','patient-004','GUIA-DEMO-1003',25000,'Glosa em recurso','2026-11-15');
INSERT OR IGNORE INTO inventory_items(id,tenant_id,unit_id,code,name,category,quantity,minimum_quantity,unit_label,lot,expires_on,status) VALUES
('item-001','tenant-med-001','unit-centro','MAT-DEMO-021','Luvas de procedimento (demo)','Material',8,20,'caixas','LOTE-DEMO-A','2027-06-30','Reposição'),
('item-002','tenant-med-001','unit-centro','MAT-DEMO-044','Máscara cirúrgica (demo)','Material',34,25,'caixas','LOTE-DEMO-B','2027-08-31','Ativo'),
('item-003','tenant-med-001','unit-jardins','MAT-DEMO-087','Gaze estéril (demo)','Material',6,15,'pacotes','LOTE-DEMO-C','2027-04-30','Reposição'),
('item-004','tenant-med-001','unit-jardins','MAT-DEMO-109','Solução antisséptica (demo)','Material',12,10,'unidades','LOTE-DEMO-D','2027-03-31','Ativo');
INSERT OR IGNORE INTO suppliers(id,tenant_id,name,contact,email,status) VALUES
('supplier-001','tenant-med-001','Fornecedor Exemplo A','(00) 90000-0201','vendas@example.invalid','Ativo'),
('supplier-002','tenant-med-001','Distribuidora Modelo B','(00) 90000-0202','contato@example.invalid','Ativo');
INSERT OR IGNORE INTO communications(id,tenant_id,unit_id,patient_id,channel,subject,status,scheduled_at,consent_status) VALUES
('comm-001','tenant-med-001','unit-centro','patient-001','E-mail fictício','Lembrete de consulta demonstrativo','Programada','2026-11-20T07:00:00-03:00','Fictício'),
('comm-002','tenant-med-001','unit-jardins','patient-003','SMS fictício','Orientação pré-atendimento demonstrativa','Enviada (demo)','2026-11-19T10:00:00-03:00','Fictício');
INSERT OR IGNORE INTO tasks(id,tenant_id,unit_id,title,category,assigned_to,due_at,status,priority) VALUES
('task-001','tenant-med-001','unit-centro','Conferir confirmações fictícias','Recepção','Equipe demonstração','2026-11-20T12:00:00-03:00','Pendente','Alta'),
('task-002','tenant-med-001','unit-jardins','Revisar reposição de materiais demo','Estoque','Equipe demonstração','2026-11-21T15:00:00-03:00','Em andamento','Normal'),
('task-003','tenant-med-001','unit-centro','Acompanhar guia fictícia','Financeiro','Equipe demonstração','2026-11-24T16:00:00-03:00','Pendente','Normal');
INSERT OR IGNORE INTO platform_subscriptions(id,tenant_id,plan_name,status,seats,renews_at) VALUES('subscription-demo','tenant-med-001','Plano Demonstração','Demo ativa',12,'2026-12-20');
