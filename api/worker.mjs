const encoder = new TextEncoder();
const json = (data, status = 200, headers = {}) => new Response(JSON.stringify(data), { status, headers: { "content-type": "application/json; charset=utf-8", "cache-control": "no-store", ...headers } });
const hex = (bytes) => [...new Uint8Array(bytes)].map((b) => b.toString(16).padStart(2, "0")).join("");
const digest = async (value) => hex(await crypto.subtle.digest("SHA-256", encoder.encode(value)));
const b64 = (bytes) => btoa(String.fromCharCode(...new Uint8Array(bytes)));
const fromB64 = (s) => Uint8Array.from(atob(s), (c) => c.charCodeAt(0));
const randomToken = () => { const b = crypto.getRandomValues(new Uint8Array(32)); return b64(b).replaceAll("+", "-").replaceAll("/", "_").replaceAll("=", ""); };
const now = () => new Date().toISOString();
const roles = {
  patients: ["owner", "manager", "reception", "clinician"], appointments: ["owner", "manager", "reception", "clinician"],
  professionals: ["owner", "manager"], services: ["owner", "manager"], rooms: ["owner", "manager"], units: ["owner", "manager"],
  clinical_records: ["owner", "clinician"], documents: ["owner", "clinician"], payments: ["owner", "manager", "finance"], expenses: ["owner", "manager", "finance"],
  insurance_plans: ["owner", "manager", "finance"], insurance_claims: ["owner", "manager", "finance"], inventory_items: ["owner", "manager"],
  suppliers: ["owner", "manager"], communications: ["owner", "manager", "reception"], tasks: ["owner", "manager", "reception", "clinician", "finance"], platform_subscriptions: ["owner"]
};
const fields = {
  patients: ["unit_id","code","full_name","phone","email","birth_date","source","status","notes"],
  appointments: ["unit_id","patient_id","professional_id","service_id","room_id","starts_at","ends_at","status","notes"],
  professionals: ["unit_id","full_name","specialty","registration","phone","email","status"], services: ["name","specialty","duration_minutes","price_cents","status"], rooms: ["unit_id","name","resource_type","status"], units: ["name","city","timezone","status"],
  clinical_records: ["unit_id","patient_id","appointment_id","professional_id","record_type","summary","status"], documents: ["unit_id","patient_id","appointment_id","professional_id","document_type","title","status","issued_at"],
  payments: ["unit_id","patient_id","description","amount_cents","method","status","due_date","settled_at"], expenses: ["unit_id","description","category","amount_cents","status","due_date","settled_at"],
  insurance_plans: ["name","registration_code","contact","status"], insurance_claims: ["unit_id","plan_id","patient_id","reference_code","amount_cents","status","submitted_at"],
  inventory_items: ["unit_id","code","name","category","quantity","minimum_quantity","unit_label","lot","expires_on","status"], suppliers: ["name","contact","email","status"],
  communications: ["unit_id","patient_id","channel","subject","status","scheduled_at","consent_status"], tasks: ["unit_id","title","category","assigned_to","due_at","status","priority"]
};
const readRoles = (resource) => roles[resource] || [];
async function verifyVerifier(verifier, pepper, expected) {
  try {
    const raw = fromB64(verifier);
    const key = await crypto.subtle.importKey("raw", encoder.encode(pepper), { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
    const actual = hex(await crypto.subtle.sign("HMAC", key, raw)); let diff = actual.length ^ expected.length;
    for (let i = 0; i < Math.min(actual.length, expected.length); i++) diff |= actual.charCodeAt(i) ^ expected.charCodeAt(i);
    return diff === 0;
  } catch { return false; }
}
async function currentUser(request, env) {
  const token = request.headers.get("authorization")?.replace(/^Bearer\s+/i, "");
  if (!token || token.length > 128) return null;
  const tokenHash = await digest(token);
  return env.DB.prepare(`SELECT u.id,u.tenant_id,u.email,u.full_name,u.role,u.status,t.name AS tenant_name,t.is_demo FROM sessions s JOIN user_accounts u ON u.id=s.user_id JOIN tenants t ON t.id=s.tenant_id WHERE s.token_hash=? AND s.revoked_at IS NULL AND s.expires_at>? AND u.status='active' AND t.status='active'`).bind(tokenHash, now()).first();
}
async function audit(env, user, action, entity, entityId) {
  await env.DB.prepare("INSERT INTO audit_events(id,tenant_id,actor_id,action,entity,entity_id,created_at) VALUES(?,?,?,?,?,?,?)").bind(crypto.randomUUID(), user.tenant_id, user.id, action, entity, entityId, now()).run();
}
const descriptors = {
  patients: {label:"Pacientes",title:"Cadastro fictício"}, appointments:{label:"Agenda e recepção",title:"Agendamento demonstrativo"}, professionals:{label:"Equipe",title:"Profissional demonstrativo"}, services:{label:"Serviços",title:"Serviço"}, rooms:{label:"Salas e recursos",title:"Sala ou recurso"}, units:{label:"Unidades",title:"Unidade"}, clinical_records:{label:"Prontuários",title:"Registro clínico fictício"}, documents:{label:"Documentos",title:"Documento demonstrativo"}, payments:{label:"Recebimentos",title:"Recebimento"}, expenses:{label:"Despesas",title:"Despesa"}, insurance_plans:{label:"Convênios",title:"Convênio"}, insurance_claims:{label:"Guias e faturamento",title:"Guia demonstrativa"}, inventory_items:{label:"Estoque",title:"Item de estoque"}, suppliers:{label:"Fornecedores",title:"Fornecedor fictício"}, communications:{label:"Relacionamento",title:"Comunicação demonstrativa"}, tasks:{label:"Tarefas",title:"Tarefa"}, platform_subscriptions:{label:"Plano da conta",title:"Assinatura demonstrativa"}
};
async function handle(request, env) {
  const url = new URL(request.url); const path = url.pathname.replace(/\/+$/, "") || "/"; const method = request.method.toUpperCase();
  if (Number(request.headers.get("content-length") || 0) > 12000) return json({ error: "Solicitação muito grande." }, 413);
  if (method === "OPTIONS") return new Response(null, { status: 204 });
  if (path === "/health" && method === "GET") return json({ ok: true, service: "meditrica-api", environment: env.ENVIRONMENT || "demo", database: "d1" });
  if (path === "/auth/challenge" && method === "GET") {
    const account = await env.DB.prepare("SELECT password_salt,password_iterations FROM user_accounts WHERE status='active' ORDER BY created_at LIMIT 1").first();
    return json({ salt: account?.password_salt || "bWVkaXRyaWNhLWRlbW8tc2FsdA==", iterations: account?.password_iterations || 310000 });
  }
  if (path === "/auth/login" && method === "POST") {
    const body = await request.json().catch(() => null); const email = typeof body?.email === "string" ? body.email.trim().toLowerCase().slice(0,254) : ""; const verifier = typeof body?.verifier === "string" ? body.verifier.slice(0,256) : "";
    if (!email || !verifier || !email.includes("@")) return json({ error: "Credenciais inválidas." }, 400);
    const identityKey = await digest(email);
    const recent = await env.DB.prepare("SELECT COUNT(*) AS n FROM auth_attempts WHERE identity_key=? AND attempted_at>? ").bind(identityKey, new Date(Date.now()-15*60*1000).toISOString()).first();
    if ((recent?.n || 0) >= 8) return json({ error: "Não foi possível entrar agora. Aguarde alguns minutos e tente novamente." }, 429);
    const account = await env.DB.prepare("SELECT id,tenant_id,email,full_name,role,password_hash,password_salt,password_iterations,status FROM user_accounts WHERE email=? LIMIT 1").bind(email).first();
    const valid = !!(account && account.status === "active" && await verifyVerifier(verifier, env.AUTH_PEPPER || "", account.password_hash));
    if (!valid) {
      await env.DB.prepare("INSERT INTO auth_attempts(identity_key,attempted_at) VALUES(?,?)").bind(identityKey, now()).run();
      return json({ error: "E-mail ou senha inválidos." }, 401);
    }
    await env.DB.prepare("DELETE FROM auth_attempts WHERE identity_key=?").bind(identityKey).run();
    const token = randomToken(); const expires = new Date(Date.now()+8*60*60*1000).toISOString();
    await env.DB.prepare("INSERT INTO sessions(id,user_id,tenant_id,token_hash,created_at,expires_at) VALUES(?,?,?,?,?,?)").bind(crypto.randomUUID(),account.id,account.tenant_id,await digest(token),now(),expires).run();
    await audit(env, account, "login", "session", account.id);
    return json({ token, expiresAt: expires, user: { id:account.id,email:account.email,name:account.full_name,role:account.role,tenantId:account.tenant_id } });
  }
  if (path === "/auth/logout" && method === "POST") {
    const token = request.headers.get("authorization")?.replace(/^Bearer\s+/i, ""); if (token) await env.DB.prepare("UPDATE sessions SET revoked_at=? WHERE token_hash=? AND revoked_at IS NULL").bind(now(),await digest(token)).run();
    return json({ ok:true });
  }
  const user = await currentUser(request, env); if (!user) return json({ error:"Sessão inválida ou expirada." }, 401);
  if (path === "/auth/me" && method === "GET") return json({ user:{ id:user.id,email:user.email,name:user.full_name,role:user.role,tenantId:user.tenant_id,clinic:user.tenant_name,demo:!!user.is_demo } });
  if (path === "/api/summary" && method === "GET") {
    if (!readRoles("patients").includes(user.role)) return json({ error:"Acesso não autorizado." },403);
    const t=user.tenant_id;
    const [patients,appointments,today,receipts,expenses,items,openTasks,claims] = await Promise.all([
      env.DB.prepare("SELECT COUNT(*) AS n FROM patients WHERE tenant_id=? AND is_archived=0").bind(t).first(),
      env.DB.prepare("SELECT COUNT(*) AS n FROM appointments WHERE tenant_id=? AND is_archived=0").bind(t).first(),
      env.DB.prepare("SELECT COUNT(*) AS n FROM appointments WHERE tenant_id=? AND is_archived=0 AND substr(starts_at,1,10)=?").bind(t,new Date().toLocaleDateString("sv-SE",{timeZone:"America/Sao_Paulo"})).first(),
      env.DB.prepare("SELECT COALESCE(SUM(amount_cents),0) AS n FROM payments WHERE tenant_id=? AND is_archived=0 AND status='Recebido'").bind(t).first(),
      env.DB.prepare("SELECT COALESCE(SUM(amount_cents),0) AS n FROM expenses WHERE tenant_id=? AND is_archived=0 AND status!='Pago'").bind(t).first(),
      env.DB.prepare("SELECT COUNT(*) AS n FROM inventory_items WHERE tenant_id=? AND is_archived=0 AND quantity<=minimum_quantity").bind(t).first(),
      env.DB.prepare("SELECT COUNT(*) AS n FROM tasks WHERE tenant_id=? AND is_archived=0 AND status!='Concluída'").bind(t).first(),
      env.DB.prepare("SELECT COUNT(*) AS n FROM insurance_claims WHERE tenant_id=? AND is_archived=0 AND status='Em análise'").bind(t).first()
    ]);
    return json({patients:patients.n,appointments:appointments.n,todayAppointments:today.n,receiptsCents:receipts.n,pendingExpensesCents:expenses.n,lowStock:items.n,openTasks:openTasks.n,claimsInReview:claims.n,updatedAt:now(),period:"Demonstração sintética"});
  }
  const parts=path.split("/").filter(Boolean); if(parts[0]!=="api" || !parts[1] || !descriptors[parts[1]]) return json({error:"Rota não encontrada."},404);
  const resource=parts[1], id=parts[2]; if(!readRoles(resource).includes(user.role)) return json({error:"Seu perfil não tem acesso a este módulo."},403);
  const tableName=resource;
  if(method==="GET" && !id){
    const result=await env.DB.prepare(`SELECT * FROM ${tableName} WHERE tenant_id=? AND is_archived=0 ORDER BY created_at DESC LIMIT 200`).bind(user.tenant_id).all();
    if(resource==="clinical_records") await audit(env,user,"read_list",resource,"collection");
    return json({items:result.results||[],label:descriptors[resource].label,fields:fields[resource]||[]});
  }
  if(method==="POST" && !id){
    const body=await request.json().catch(()=>null); if(!body||typeof body!=="object"||Array.isArray(body)) return json({error:"Dados inválidos."},400);
    const allowed=fields[resource]||[], entries=Object.entries(body).filter(([k,v])=>allowed.includes(k)&&v!==undefined&&v!==null&&["string","number","boolean"].includes(typeof v)&&String(v).length<=2000&&(typeof v!=="number"||Number.isFinite(v)));
    const required={patients:["code","full_name"],appointments:["starts_at"],professionals:["full_name","specialty"],services:["name"],rooms:["name"],units:["name"],clinical_records:["summary"],documents:["document_type","title"],payments:["description"],expenses:["description"],insurance_plans:["name"],insurance_claims:["reference_code"],inventory_items:["code","name"],suppliers:["name"],communications:["subject"],tasks:["title"]}[resource]||[];
    if(required.some(k=>!entries.some(e=>e[0]===k))) return json({error:"Preencha os campos obrigatórios."},422);
    const references={unit_id:"units",patient_id:"patients",professional_id:"professionals",service_id:"services",room_id:"rooms",appointment_id:"appointments",plan_id:"insurance_plans"};
    for(const [key,value] of entries){const table=references[key];if(table&&value){const parent=await env.DB.prepare(`SELECT id FROM ${table} WHERE id=? AND tenant_id=? AND is_archived=0`).bind(value,user.tenant_id).first();if(!parent)return json({error:"Referência não encontrada nesta clínica."},422);}}
    const recordId=crypto.randomUUID(), stamp=now(), keys=["id","tenant_id",...entries.map(e=>e[0]),"is_archived","created_at","updated_at"], values=[recordId,user.tenant_id,...entries.map(e=>e[1]),0,stamp,stamp];
    await env.DB.prepare(`INSERT INTO ${tableName} (${keys.join(",")}) VALUES (${keys.map(()=>"?").join(",")})`).bind(...values).run();
    await audit(env,user,"create",resource,recordId); return json({id:recordId,ok:true},201);
  }
  if(method==="PATCH" && id){
    const body=await request.json().catch(()=>null); if(!body||typeof body!=="object"||Array.isArray(body)) return json({error:"Dados inválidos."},400);
    const entries=Object.entries(body).filter(([k,v])=>(fields[resource]||[]).includes(k)&&v!==undefined&&v!==null&&["string","number","boolean"].includes(typeof v)&&String(v).length<=2000&&(typeof v!=="number"||Number.isFinite(v))); if(!entries.length) return json({error:"Nenhum campo válido para atualizar."},422);
    const references={unit_id:"units",patient_id:"patients",professional_id:"professionals",service_id:"services",room_id:"rooms",appointment_id:"appointments",plan_id:"insurance_plans"};
    for(const [key,value] of entries){const table=references[key];if(table&&value){const parent=await env.DB.prepare(`SELECT id FROM ${table} WHERE id=? AND tenant_id=? AND is_archived=0`).bind(value,user.tenant_id).first();if(!parent)return json({error:"Referência não encontrada nesta clínica."},422);}}
    const result=await env.DB.prepare(`UPDATE ${tableName} SET ${entries.map(([k])=>`${k}=?`).join(",")},updated_at=? WHERE id=? AND tenant_id=? AND is_archived=0`).bind(...entries.map(e=>e[1]),now(),id,user.tenant_id).run();
    if(!result.meta?.changes) return json({error:"Registro não encontrado."},404); await audit(env,user,"update",resource,id); return json({ok:true});
  }
  if(method==="DELETE" && id){
    if(resource==="clinical_records" && user.role!=="owner" && user.role!=="clinician") return json({error:"Acesso não autorizado."},403);
    const result=await env.DB.prepare(`UPDATE ${tableName} SET is_archived=1,updated_at=? WHERE id=? AND tenant_id=? AND is_archived=0`).bind(now(),id,user.tenant_id).run();
    if(!result.meta?.changes) return json({error:"Registro não encontrado."},404); await audit(env,user,"archive",resource,id); return json({ok:true});
  }
  return json({error:"Método não permitido."},405,{allow:"GET,POST,PATCH,DELETE"});
}
export default { async fetch(request, env) { try { return await handle(request, env); } catch (error) { console.error("request_failed", error?.message || "unknown"); return json({error:"Falha ao processar a solicitação."},500); } } };
