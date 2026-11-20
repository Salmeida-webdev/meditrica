const API = "https://meditrica-api.dona-de-ouro-demo.workers.dev";
const COOKIE = "__Host-md_session";
const commonHeaders = { "content-type": "application/json; charset=utf-8", "cache-control": "no-store", "x-content-type-options": "nosniff" };
export default async (request: Request) => {
  const origin = request.headers.get("origin");
  if (origin && origin !== "https://meditrica.netlify.app") return new Response(JSON.stringify({ error: "Origem não permitida." }), { status: 403, headers: commonHeaders });
  const url = new URL(request.url); const path = (url.searchParams.get("path") || "").replace(/^\/+|\/+$/g, "");
  if (!/^(auth\/(challenge|login|me|logout)|api\/(summary|[a-z_]+(?:\/[a-f0-9-]+)?))$/.test(path)) return new Response(JSON.stringify({ error: "Rota não encontrada." }), { status: 404, headers: commonHeaders });
  const cookies = request.headers.get("cookie") || ""; const token = cookies.split(";").map(x => x.trim()).find(x => x.startsWith(COOKIE + "="))?.slice(COOKIE.length + 1);
  const isLogin = path === "auth/login"; const isLogout = path === "auth/logout";
  if (!isLogin && path !== "auth/me" && path !== "auth/challenge" && !token) return new Response(JSON.stringify({ error: "Sessão inválida ou expirada." }), { status: 401, headers: commonHeaders });
  const headers = new Headers({ "accept": "application/json" }); if (token) headers.set("authorization", `Bearer ${decodeURIComponent(token)}`);
  let body: string | undefined;
  if (["POST", "PATCH"].includes(request.method)) { const text = await request.text(); if (text.length > 12000) return new Response(JSON.stringify({ error: "Solicitação muito grande." }), { status: 413, headers: commonHeaders }); body = text; headers.set("content-type", "application/json"); }
  const upstream = await fetch(`${API}/${path}`, { method: request.method, headers, body });
  const data = await upstream.json().catch(() => ({ error: "Resposta inválida do serviço." }));
  if (isLogin && upstream.ok) {
    const sessionToken = data.token; if (typeof sessionToken !== "string" || !data.user) return new Response(JSON.stringify({ error: "Não foi possível iniciar a sessão." }), { status: 502, headers: commonHeaders });
    const safeUser = data.user; const response = new Response(JSON.stringify({ user: safeUser, expiresAt: data.expiresAt }), { status: 200, headers: commonHeaders });
    response.headers.append("set-cookie", `${COOKIE}=${encodeURIComponent(sessionToken)}; Path=/; Secure; HttpOnly; SameSite=Lax; Max-Age=28800`); return response;
  }
  const response = new Response(JSON.stringify(data), { status: upstream.status, headers: commonHeaders });
  if (isLogout) response.headers.append("set-cookie", `${COOKIE}=; Path=/; Secure; HttpOnly; SameSite=Lax; Max-Age=0`);
  return response;
};
