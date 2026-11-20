# Medítrica — baseline de segurança e privacidade

Este baseline orienta a implementação; não é certificação nem declaração de conformidade legal.

## Dados de saúde e privacidade

- Tratar dados de saúde como dados pessoais sensíveis; coletar somente o necessário para finalidade definida.
- Separar dados da conta SaaS, cadastros administrativos e registros clínicos.
- Definir papéis de controlador/operador, bases legais, retenção, atendimento aos titulares, contratos e resposta a incidentes com assessoria especializada antes da produção.
- Não usar dados reais em seed, screenshots, previews, logs ou suporte.
- Não enviar conteúdo clínico a ferramentas de analytics, logs de aplicação ou IA sem análise específica, base legal e controles apropriados.

## Controles obrigatórios antes de dados reais

- MFA ativado nas contas de GitHub, Cloudflare e Netlify; revisar sessões e tokens.
- Senha que foi colada em conversa deve ser trocada imediatamente e não será reutilizada.
- Tenant e unidade são verificados no servidor em cada leitura/escrita; nunca confiar no tenant enviado pelo navegador.
- Permissões por papel e escopo são negadas por padrão e checadas no servidor.
- Cookies de sessão Secure, HttpOnly e SameSite; proteção CSRF quando aplicável; rotação, expiração, revogação e recuperação segura de conta.
- Limites de tentativas, rate limiting, validação de payload, statements parametrizados, cabeçalhos de segurança e política CSP.
- Trilha de auditoria para acesso e alteração de informação clínica, documentos, permissões e exportações; proteger contra alteração por usuários comuns.
- Criptografia em trânsito e repouso; anexos em storage privado; links temporários e autorizados.
- Segredos fora do repositório; escopo mínimo; rotação e inventário de chaves.
- Backups, retenção, restauração ensaiada, plano de continuidade e procedimento de incidente.
- Dependências e builds revisados; proteção de branch; revisão de mudanças; bloqueio de deploy com falha de build ou credenciais detectadas.

## Gatilhos de produção

Não habilitar pacientes reais antes de: revisão de ameaça; auditoria de isolamento multi-tenant; validação de autenticação/recuperação; revisão LGPD/contratos; política de retenção; teste de restauração; monitoramento de erros sem conteúdo clínico; procedimento de resposta a incidentes; aprovação do responsável clínico e operacional.

## Situação observada na configuração inicial

- Netlify: projeto com exigência de SSO; perfil da conta retornou MFA desativado.
- Cloudflare: configuração de conta retornou exigência global de MFA desativada.
- A liberação pública do projeto Netlify não foi aplicada: a revisão automática identificou que a ferramenta alteraria proteção de todos os deploys do site. Manter previews protegidos até que uma configuração de escopo restrito possa ser confirmada.
