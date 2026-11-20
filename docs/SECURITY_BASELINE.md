# Medítrica — baseline de segurança da demonstração

Status: controles iniciais ativos para a demonstração com dados sintéticos. Este documento não é auditoria independente, certificação, parecer legal ou declaração de conformidade.

## Controles implementados

- Os ambientes D1 `meditrica-dev`, `meditrica-staging` e `meditrica-prod` estão separados e contêm apenas registros fictícios.
- Landing e área de gestão são servidas no Netlify. A função same-origin mantém o token fora do JavaScript e usa cookie `Secure`, `HttpOnly`, `SameSite=Lax`, `Path=/`, com validade de oito horas.
- Token de sessão opaco e aleatório; no D1 fica somente seu SHA-256, com expiração e revogação por logout.
- Senha nunca é armazenada em texto aberto no repositório ou no D1. O navegador deriva PBKDF2-HMAC-SHA256 com 310.000 iterações; o Worker verifica um HMAC protegido por `AUTH_PEPPER`, configurado como secret binding separado em cada Worker.
- O Worker aplica limite de oito tentativas inválidas por identidade e janela de 15 minutos, erros de login genéricos e limite de payload na função Netlify.
- Rotas e campos aceitos são allowlist. O Worker valida papel, sessão, tenant e referências a registros do mesmo tenant; consultas são parametrizadas.
- Escritas e arquivamentos criam eventos de auditoria. O arquivamento mantém o registro recuperável.
- Cabeçalhos de segurança estão configurados no Netlify. A CSP atual permite scripts inline por compatibilidade com as páginas existentes; não equivale a CSP estrita.
- Dados demonstrativos não são enviados a analytics externos. Contatos usam domínio reservado `example.invalid`.

## Restrições atuais

- Uma conta proprietária e um tenant demonstrativo. Ainda não há convite ou administração de usuários, recuperação de conta ou MFA dentro do produto.
- O app não é pronto para produção clínica, não foi avaliado por auditoria externa e não deve receber dados reais de pacientes.
- O prontuário contém placeholders sem conteúdo assistencial; modelos de documentos não são documentos médicos válidos.
- A trilha de auditoria não é storage WORM nem imutável; não há rotina de backup/restore ensaiada nesta demo.
- A chave Pepper fica no secret store Cloudflare; requer rotação planejada e procedimentos de recuperação que ainda não estão automatizados.
- Um verificador de login é uma credencial equivalente durante o transporte; proteger o site contra XSS e scripts de terceiros é essencial.

## Gatilhos antes de dados reais

Revisão independente de ameaça, autorização e isolamento multi-tenant; XSS/CSP; MFA e recuperação; rotação de segredos; backup e restauração ensaiados; revisão de dependências e pipeline; avaliação LGPD, contratos, base legal e retenção; processo de incidentes; monitoramento sem conteúdo clínico; aprovação dos responsáveis clínico e operacional.

## Credencial da demonstração

A senha fornecida pelo proprietário foi usada apenas para provisionar a conta demonstrativa. Como ela foi compartilhada na conversa e pode estar em uso em outros serviços, não deve ser reutilizada fora desta demo e deve ser trocada depois da demonstração. Nenhum segredo está versionado no Git.
