# Medítrica — arquitetura inicial

Status: fundação em planejamento e provisionamento. Este documento não declara o produto pronto para uso clínico.

## Decisões iniciais

- Repositório independente: `Salmeida-webdev/meditrica`.
- Site Netlify: `meditrica.netlify.app`, na conta de publicação indicada pelo proprietário.
- Ambientes D1 separados: `meditrica-dev`, `meditrica-staging` e `meditrica-prod`.
- Frontend público e painel web no Netlify; serviços de API e tarefas assíncronas no Cloudflare Workers.
- Cloudflare D1 como banco relacional inicial, com migrações versionadas e aplicadas separadamente por ambiente. Validar carga, limites, concorrência e estratégia de crescimento antes de produção.
- Documentos clínicos, quando implementados, em buckets R2 privados por ambiente; nunca em URLs públicas permanentes.
- Nenhum dado clínico real será usado em desenvolvimento, demonstração ou homologação.

## Separação de responsabilidades

1. Landing e aplicação web não recebem credenciais privilegiadas do Cloudflare.
2. Workers validam sessão, tenant, permissões e entrada em toda operação.
3. Cada registro clínico fica vinculado a tenant e unidade; autorização sempre é aplicada no servidor.
4. D1 recebe consultas parametrizadas por statements preparados. Migrações são auditáveis e reversíveis quando tecnicamente possível.
5. R2 guarda anexos privados, com autorização curta e explícita para leitura/download.
6. Filas Cloudflare ficam reservadas para lembretes, importações e tarefas demoradas, com idempotência, retry limitado e dead-letter quando apropriado.

## Reuso do Beauty Core

Reutilizar apenas componentes genéricos depois de revisão de código e dependências: tokens visuais, componentes, layout, formulários, padrões de sessão, papéis e trilhas de auditoria. Não copiar conteúdo, marca, identidade, modelos de estética, dados ou segredos. O backend NestJS/Prisma/PostgreSQL não é plug-and-play com D1; serviços e persistência precisam ser adaptados e revistos antes de migração.

## Ambientes

| Ambiente | Banco | Dados | Uso |
| --- | --- | --- | --- |
| Desenvolvimento | meditrica-dev | Sintéticos | Desenvolvimento local |
| Homologação | meditrica-staging | Sintéticos | Revisão de fluxos e releases |
| Produção | meditrica-prod | Somente dados autorizados | Operação após gates de segurança |

Segredos serão separados por ambiente e guardados no secret store do Worker ou provedor; nunca no Git, no bundle do navegador ou em variáveis públicas `NEXT_PUBLIC_*`.

## Implantação

Netlify deve publicar apenas artefatos do frontend. Workers e migrations têm pipeline separado e aprovação de release. Pull requests usarão previews sem dados reais. A publicação só será considerada concluída após ligação segura GitHub–Netlify, build com sucesso e verificação do domínio.

## Limite atual

Os três bancos foram criados, mas ainda não têm schema/migrations nem dados. Ainda não existem API, autenticação do produto, prontuário, agenda ou gestão clínica operacionais. O site Netlify está reservado, sem deploy publicado.
