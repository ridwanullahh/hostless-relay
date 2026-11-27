# hostless-relay

Private fleet-ops relay for the BirrStack fleet API-backend split to Hostless.

Bismillah Ar-Rahman Ar-Raheem. Ash-hadu an laa ilaaha illa-Llah wahdaHu lasharikalaHu, wa ash-hadu anna Muhammadan Abduhu wa Rasooluh. Laa hawla wa laa quwwata illaa biLLAH. Hasbiyallaahu laa ilaaha illaa Huwa, 'alayhi tawakkaltu wa Huwa Rabbul-'Arshil-'Azeem. SubhaanALLAH wa bihamdih, SubhaanALLAHil-'azeem, AlhamduliLLAH, Laa ilaaha illa-ALLAH, wa ALLAHU AKBAR, walaa hawla walaa quwwata illaa biLLAH. Astaghfirullaaha wa atoobu ilayh.

## Why this exists
The fleet split deploys each platform's standalone API backend (extracted from the BirrStack-Server-Beta1 monorepo) to a dedicated Hostless service. The build sandbox IP is blocked by Hostless' WAF, so Hostless API calls run here on GitHub-hosted runners. Credentials live ONLY as repo secrets (HOSTLESS_TOKEN, GH_PAT, HV_<APP>_ENVS base64 env payload per app) — never in code, never in logs (values are masked).

## Ops (dispatch `hostless-ops` workflow)
- `list` — list Hostless projects + apps
- `create` — clone pair repo, create app from its `server/` monorepo backend (hostless.yaml driven), wait for deploy
- `env-set` — decode HV_<APP>_ENVS and set env vars on the app
- `deploy` — deploy latest pushed commit of the pair repo to the app
- `info` — show app details (URL, deployments)

## Guards
- The API backend (`server/` of each pair repo) must NEVER deploy to Cloudflare Pages; frontends must NEVER deploy to Hostless. hostless.yaml declares `working_directory: server` + Docker build only.
- Never wipe existing env vars: env-set sends the complete merged set (Render harvest + missing).
