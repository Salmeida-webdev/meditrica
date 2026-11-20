# Medítrica

Plataforma SaaS brasileira para gestão integrada de clínicas médicas.

> Em desenvolvimento. A landing apresenta a visão do produto; não há login, prontuário ou operações clínicas disponíveis. Não utilizar para atendimento nem inserir dados reais.

## Ambientes provisionados

- Cloudflare D1: `meditrica-dev`, `meditrica-staging`, `meditrica-prod` (sem schema/dados até o momento).
- Netlify: projeto `meditrica` na conta `segundolmx`.
- GitHub: repositório privado `Salmeida-webdev/meditrica`.

## Estrutura atual

- `index.html`: landing page responsiva inicial.
- `docs/ARCHITECTURE.md`: decisões técnicas e limites atuais.
- `docs/SECURITY_BASELINE.md`: controles obrigatórios antes de dados reais.
- `docs/ROADMAP.md`: etapas do produto.

## Publicação

A landing é estática e configurada para publicar a raiz do repositório no Netlify. A integração de deploy GitHub–Netlify ainda precisa ser concluída; o projeto Netlify não tem deploy publicado.

## Segurança

Não envie segredos, tokens, credenciais ou dados clínicos ao repositório. Consulte `docs/SECURITY_BASELINE.md` antes de implementar autenticação ou persistência.
