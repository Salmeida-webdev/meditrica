# Medítrica — arquitetura da demo operacional

## Topologia

| Camada | Serviço | Escopo |
| --- | --- | --- |
| Landing, login e gestão | Netlify static | HTML responsivo; publicação via GitHub privado |
| Proxy de sessão | Netlify Function | Mesmo domínio do navegador; envia token HttpOnly ao Worker por Authorization |
| API | Cloudflare Workers | Valida sessão, tenant, papel e payload; statements D1 parametrizados |
| Dados | Cloudflare D1 | `meditrica-dev`, `meditrica-staging`, `meditrica-prod`, cada qual com Worker próprio |

Os três bancos contêm somente dados sintéticos. A instância `prod` serve exclusivamente a demonstração pública e não pode receber pacientes reais.

## Sessão e autenticação

1. A página de login obtém o salt e o fator de custo do usuário demo.
2. O navegador deriva um verificador com PBKDF2-HMAC-SHA256 e envia o verificador por TLS ao endpoint same-origin do Netlify.
3. O Worker compara um HMAC desse verificador usando `AUTH_PEPPER` guardado no secret store com o verificador HMAC armazenado no D1. A senha não entra no repositório ou nos logs da aplicação.
4. O Worker cria um token aleatório de sessão e grava somente seu SHA-256 no D1. O proxy guarda o token em cookie `Secure`, `HttpOnly`, `SameSite=Lax` por oito horas.
5. Nas chamadas seguintes, o proxy encaminha o cookie como Bearer para o Worker; sessão, status de usuário e tenant são consultados no servidor. Logout revoga a sessão.

O verificador enviado pelo navegador é uma credencial equivalente somente durante o transporte TLS. A página não deve receber scripts de terceiros ou dados reais sem uma revisão adicional de CSP e XSS.

## Dados e permissões

As tabelas modelam clínicas, unidades, usuários, sessões, tentativas de autenticação, pacientes fictícios, profissionais, agenda, registros demonstrativos, documentos, financeiro, convênios, estoque, fornecedores, comunicação, tarefas e auditoria. Tabelas operacionais têm `tenant_id`; consultas e gravações filtram pelo tenant obtido da sessão autenticada. As regras de recursos e papéis são definidas no Worker e negam acesso por padrão.

A função de arquivamento usa `is_archived`; as ações de criação, edição e arquivamento gravam actor, entidade e ação em `audit_events`. A trilha atual é adequada à demonstração, mas não é WORM nem auditoria imutável certificada.

## Migrations e dados

- `migrations/0001_core.sql`: schema e índices.
- `migrations/0002_demo_data.sql`: seed de dados sintéticos.
- `migrations/0003_expanded_demo_data.sql`: amplia os exemplos sintéticos dos fluxos operacionais.
- A conta de demonstração é provisionada separadamente; apenas o verificador, salt e fator de custo são gravados no D1.
- As mesmas migrations são aplicadas de forma isolada em dev, staging e prod.

## Limitações e gate de dados reais

A demo não implementa MFA, recuperação de senha, convite de usuários, escolha entre tenants para e-mail duplicado, anexos privados, rotina de backup/restore, telemedicina, emissão fiscal, integrações oficiais ou gestão completa da plataforma. O módulo clínico tem registros sem conteúdo assistencial e documentos sem validade médica.

Antes de dados reais: auditoria independente de autorização multi-tenant e sessões; revisão XSS/CSP; MFA e recuperação; gestão de segredos e rotação; backups e restauração ensaiada; avaliação LGPD, contratos e retenção; responsáveis clínicos e aprovação operacional; controles de incidente e observabilidade sem payload clínico.
