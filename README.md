# Medítrica

SaaS brasileira de gestão integrada para clínicas. O site público e a área de demonstração estão publicados em `https://meditrica.netlify.app`.

## Acesso à demonstração

- Landing: `/`
- Prévia pública somente ilustrativa: `/demo`
- Login da área de gestão: `/login`
- Área autenticada: `/gestao`
- A conta demonstrativa usa o e-mail proprietário informado pelo cliente e a senha fornecida diretamente por ele. A senha não está no repositório; o banco guarda somente um verificador derivado, protegido por um segredo Cloudflare.

**Use somente para demonstração.** Todos os dados são sintéticos. Não incluir dados pessoais reais nem conteúdo clínico, e não usar para atendimento médico.

## Arquitetura ativa

- Frontend estático e Netlify Function proxy no Netlify.
- API em Cloudflare Workers com uma instância por ambiente.
- D1 com bancos separados: `meditrica-dev`, `meditrica-staging` e `meditrica-prod`. Todos têm schema e dados sintéticos isolados.
- Sessão opaca de 8 horas, armazenada como hash no D1 e entregue ao navegador em cookie `Secure`, `HttpOnly`, `SameSite=Lax`. Logout revoga a sessão.
- Login: PBKDF2-HMAC-SHA256 no navegador (310.000 iterações), verificador protegido por pepper no Worker. Segredos ficam no secret store Cloudflare, nunca no Git.
- Permissões por papel são verificadas na API. O tenant vem da sessão validada; não é aceito do navegador.
- Escritas geram trilha de auditoria; exclusões são arquivamentos recuperáveis.

## Módulos da demonstração

Painel e indicadores; agenda e recepção; pacientes fictícios; registros e documentos demonstrativos; recebimentos e despesas; convênios e guias; estoque; equipe, unidades, serviços, salas e fornecedores; relacionamento e tarefas; assinatura demonstrativa da plataforma.

Os módulos permitem listar, criar, editar, arquivar e exportar registros sintéticos. O prontuário é apenas uma estrutura de demonstração e não emite documentos médicos válidos.

## Desenvolvimento e deploy

- `index.html`, `demo.html`, `login.html`, `app.html`: páginas do produto.
- `netlify/functions/api.mts`: proxy same-origin que mantém o token em cookie HttpOnly.
- `api/worker.mjs`: API Cloudflare Workers.
- `migrations/`: schema e seed sintético versionados.
- `netlify.toml`, `_redirects`: publicação e rotas do site.

O deploy do frontend é integrado ao repositório GitHub privado. Workers e migrações são publicados separadamente para manter os três ambientes isolados.

## Limites antes de uso clínico real

Esta entrega é uma demo operacional com um tenant e uma conta proprietária. Ainda requer revisão independente de segurança, testes de isolamento multi-tenant, fluxos de recuperação/MFA e gestão de usuários, backup e restauração ensaiados, avaliação jurídica/LGPD, aprovação clínica, contratos, retenção, monitoramento e revisão das integrações antes de receber dados reais. Não há telemedicina, faturamento fiscal, WhatsApp oficial ou armazenamento de anexos clínicos nesta demo.
