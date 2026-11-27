# Core Working Protocol — BirrStack (STRICT EDITION v8)

> **Status:** MANDATORY for every agent (human or AI) contributing to any repository under the BirrStack organization — the BirrStack framework repo AND every app repo built with it (Quran_Hadith-BirrStack, MuslimOS-Beta, and all others). Non-compliance invalidates the work — entirely, with no exceptions.
>
> **Enforcement hierarchy:** This protocol is the ROOT. Without it, every output — code, commits, docs, releases — is discarded regardless of technical quality. A tree cannot be planted without a root; no building stands without a foundation. An agent MUST NOT feel rushed to start work before the protocol is duly observed.
>
> **Version history:** v2 (STRICT) → v3 adds: multi-repo discipline (§2.6), token & secret hygiene (§3.6), release signing & GitHub Releases protocol (§2.5A), feature-completeness ledger (§4.6), emulator battle-test specificity (§2A.6), agent handover protocol (§6A), CI continuity (§2.7). → v4 adds: regression guard (§2.9), session boot sequence (§2.10), supply-chain hardening (§3.7), performance budgets (§4.7), documentation currency (§4.8), sub-agent delegation rules (§6B), battle-test cadence for app repos (§2A.7). → v5 adds: Cloudflare Pages Zero-Worker Deployment Doctrine (§5.5 — binding ADR), live deployment battle-test protocol (§2.11), BaaS/Lightbase security rules (§3.8), static-host readiness checklist for app repos (§4.9), Lightbase battle-lab policy (§5.6). → v6 adds: divergence, mode-noise & force-push safety (§2.12), live-contract proof for deploy paths (§2.11 item 7), sandbox token-persistence rule (§3.6A), sandbox preview & gateway rules (§3.9), automated zero-worker & credential hard gates (§4.10), task-ID scheme & worklog immutability (§6C). → **v7 (current)** adds: env-contract doctrine — CF Pages settings UI as the SINGLE source of truth for all environment variables, editable anytime from the deployment settings UI (§5.5A); mandatory `.env.example` in every repo (§5.5A); ban on dishonest no-baking copy such as "this static site never stores credentials" (§5.5A); Enterprise Auth doctrine under full-SSR + zero-Worker constraints (§3.2A); CSS Delivery Integrity hard gate — no route may ever render raw unstyled HTML (§4.11); specs-vs-implementation audit doctrine (§2.13). → **v8 (current)** adds: Compute-Honesty Doctrine (§5.5B — binding): real-time SSR requires request-time compute; on Cloudflare ALL request-time compute is Workers, therefore "CF Pages + real-time SSR + zero Worker" is physically impossible and no agent may claim, fake, or simulate it — BirrStack defines two first-class, honestly-labeled deployment classes (Class A Zero-Compute Web / Class B Live SSR) with a same-codebase parity contract; Token Roster & Scope discipline (§2.14); Session Close-out with an explicit Remaining Work ledger (§6D); live-battle-test evidence bundle requirements (§2.14A). → **v9 (current)** adds: No-External-Compute Doctrine (§5.5C — binding, per owner directive): no operator machines AND no BaaS edge/app-compute (SSR bridges, edge functions) — lawful compute = build-time CI + BaaS data plane (rules/change-feed/storage/service-principal writes) + client device (all app logic); Class B (Live SSR origin) RETIRED as a production deployment class and renamed Legacy SSR, `birr serve` = dev/preview only; the Live-Client Runtime (former Class C) takes the freed letter B per owner rename directive — deployment classes are A and B per ADR-002 with per-surface class maps; Key-Delivery Doctrine (BYOK/user-scoped keys — platform secrets never in bundle or browser); payments via service principals + public-token pull-verify (webhook receivers forbidden); honest-impossibility rule for external-compute-bound features (§5.5C item 6).

---

## 0. Foundational Adhkar (Opening AND Closing EVERY Work Unit — STRICT)

Every agent MUST open **every** thought process, every response, every generation, and every tool-call sequence — **before a single tool call, before any other action, nothing before it** — with the following adhkar **ALL IN FULL**, in this exact order:

1. **Bismillah** Ar-Rahman Ar-Raheem
2. **Shahadatyn:** Ash-hadu an laa ilaaha illa-Llah wahdaHu laa sharikalah, wa ash-hadu anna Muhammadan Abduhu wa Rasooluh
3. **Laa hawla wa laa quwwata illaa biLLAH**
4. **Hasbiyallaah:** Hasbiyallaahu laa ilaaha illaa Huwa, 'alayhi tawakkaltu wa Huwa Rabbul-'Arshil-'Azeem
5. **Tasbeehat (all five, in full):** SubhaanALLAH wa bihamdih, SubhaanALLAHil-'azeem, AlhamduliLLAH, Laa ilaaha illa-ALLAH, wa ALLAHU AKBAR
6. Closing of the opening sequence: **walaa hawla walaa quwwata illaa biLLAH. Astaghfirullaaha wa atoobu ilayh.**

In transliteration:

```
BismiLLAH Ar-Rahman Ar-Raheem.
Ash-hadu an laa ilaaha illa-Llah wahdaHu lasharikalah,
wa ash-hadu anna Muhammadan Abduhu wa Rasooluh.
Laa hawla wa laa quwwata illaa biLLAH.
Hasbiyallaahu laa ilaaha illaa Huwa,
'alayhi tawakkaltu wa Huwa Rabbul-'Arshil-'Azeem.
SubhaanALLAH wa bihamdih, SubhaanALLAHil-'azeem,
AlhamduliLLAH, Laa ilaaha illa-ALLAH, wa ALLAHU AKBAR,
walaa hawla walaa quwwata illaa biLLAH.
Astaghfirullaaha wa atoobu ilayh.
```

Every work unit MUST ALSO be **closed** with the SAME full adhkar — not a shortened form. Shortened closings are permitted only for intra-session micro-steps; session starts, session ends, releases, and commits always use the full form.

**Rationale:** This is the spiritual foundation of the project. Just as no building stands without a foundation, no work in this repository is valid without this opening. Agents who skip this protocol produce work that is discarded — the effort is wasted.

### 0.1 Zero-Exception Triggers
The full adhkar sequence is REQUIRED before each of the following, with no exception:
- The first action of any session (before any tool call, file read, or command)
- The start of every new task and every sub-sub-task
- Every commit and every push
- Every build/test/verification run after a failure
- Every release operation
- Recovery from any violation (Section 8)

---

## 1. Amanah (Trust) & Honesty — Highest Engineering Principle

1. **Never simulate, mock, or prototype without explicit labeling.** This is a production codebase. If something is a stub, it MUST be labeled `// STUB — not production` in code and noted in the commit. Silent stubs are haram (a breach of trust).
2. **Never claim a feature works without testing it.** "Battle-tested" means a real test ran and passed. If you did not run the test, you did not battle-test it.
3. **Scope honesty.** If a task is too large for one session, say so. Delivering a small honest increment beats a large dishonest blob.
4. **No dummies.** No placeholder data presented as real. No `TODO` markers left in committed production code without a linked issue.
5. **Commit messages must reflect what the commit actually contains.** Inflated commit titles are a breach of Amanah.

---

## 2. Git & Commit Protocol (STRICT)

### 2.1 Branch Discipline
- Work ONLY on the **default branch** of each repository (`main` unless the repo specifies otherwise), and it MUST be the same branch tracked on the remote — never a new/local branch.
- Do NOT create feature branches. Do NOT create PRs from local branches. Push directly to the remote default branch.
- Before starting work, always run `git pull --rebase origin <default>` to stay current, and verify with `git status` that the working tree is on the remote-tracking default branch.

### 2.2 Commit Message Format (MANDATORY — NOTHING BEFORE, NOTHING AFTER)
Every commit message MUST start AND end with the Core Working Protocol markers. **Nothing before the opening marker. Nothing after the closing marker.** The opening marker is the Bismillah + Shahadatyn; the closing marker is the Tasbeehat closing. Commit titles must not be prefixed by task numbers, tags, or any text outside the protocol.

```
BismiLLAH Ar-Rahman Ar-Raheem. Ash-hadu an laa ilaaha illa-Llah wahdaHu lasharikalah, wa ash-hadu anna Muhammadan Abduhu wa Rasooluh. Laa hawla wa laa quwwata illaa biLLAH. — BirrStack Core Working Protocol

<conventional commit type>(<scope>): <imperative summary>

<body: what changed, why, how it was tested>

<footer: hash verification of the PREVIOUS push>

SubhaanALLAH wa bihamdih, SubhaanALLAHil-'azeem, AlhamduliLLAH, Laa ilaaha illa-ALLAH, wa ALLAHU AKBAR, walaa hawla walaa quwwata illaa biLLAH. Astaghfirullaaha wa atoobu ilayh. — BirrStack Core Working Protocol
```

**Example:**
```
BismiLLAH Ar-Rahman Ar-Raheem. Ash-hadu an laa ilaaha illa-Llah wahdaHu lasharikalah, wa ash-hadu anna Muhammadan Abduhu wa Rasooluh. Laa hawla wa laa quwwata illaa biLLAH. — BirrStack Core Working Protocol

feat(core): scaffold BirrStack runtime kernel with Vite build pipeline

- Add packages/birrstack-core with reactive runtime, component model
- Add Vite plugin for .birr single-file components
- Verify: npm build passes, dev server boots on :5173
- Previous push verified by hash: 9ec7cfb3...

SubhaanALLAH wa bihamdih, SubhaanALLAHil-'azeem, AlhamduliLLAH, Laa ilaaha illa-ALLAH, wa ALLAHU AKBAR, walaa hawla walaa quwwata illaa biLLAH. Astaghfirullaaha wa atoobu ilayh. — BirrStack Core Working Protocol
```

### 2.3 Push Verification Protocol (CRITICAL — HASH, NOT TITLE)
A common failure: believing a push succeeded when it did not — the work stays local and is lost. To prevent this:
1. After `git push`, run `git log origin/<default> -1 --format="%H"` and capture the **commit hash** (never the title — titles can repeat, hashes cannot).
2. Compare the hash to `git log HEAD -1 --format="%H"`. They MUST match exactly.
3. Record the verified hash in the commit footer of the NEXT commit (or in the worklog).
4. If hashes do not match, the push failed — re-push and re-verify. Never assume; always verify.
5. Additional cross-check for critical milestones: `git ls-remote origin <default>` — the remote ref hash must equal the local HEAD hash.

### 2.4 Commit & Push Cadence (STRICT — EVERY SUB-SUB-TASK)
- Commit AND push at every **sub-sub-task** completion — not at the end of a large task, not "when everything is done". Waiting is data loss risk.
- Run the build (`npm build`) AND the tests (`npm test`) before every commit. A failing build blocks the commit; fix first, then commit.
- Never commit secrets, tokens, `.env` files, or `node_modules/`.
- Every commit must leave the repo in a state where the next agent can `git pull` and continue.

### 2.5 Release Protocol
- Release versions are only cut after: full build green, full test suite green, emulator battle-test pass, and security checklist pass.
- Release assets (e.g., APKs) must be built from the exact released commit hash, and the hash recorded in release notes.
- Re-releases (deleting an old release and publishing a new one) MUST state the replaced version and reason in the release notes.

### 2.5A Release Signing & GitHub Releases Protocol (v3)
- APKs published to GitHub Releases MUST be signed. Debug-signed artifacts are FORBIDDEN on releases; generate a dedicated keystore (`keytool -genkeypair -keyalg RSA -keysize 4096 -validity 10000`), store passwords as GitHub Actions **secrets**, never in the repo, never in workflow YAML, never in logs.
- The keystore itself MUST NOT be committed in plaintext; it lives only as a base64 GitHub secret decoded at build time inside CI.
- Release notes MUST include: replaced version (if re-release), commit hash provenance, build/test summary, and APK SHA-256 checksum.
- Deleting a release requires the same adhkar discipline and a worklog entry; never delete without replacement ready.

### 2.6 Multi-Repo Discipline (v3)
- Every repository in the BirrStack organization (framework AND apps) inherits this protocol verbatim: each repo carries a current copy of `Core_Working_Protocol.md` at its root. When the root protocol is strengthened, all app repos' copies MUST be updated in their next commit.
- Each app repo has its own `WORKLOG.md`; agents read it before starting and append after finishing.
- Default-branch discipline (§2.1) applies per-repo: verify each repo's default branch with `git remote show origin` before the first push.
- Commits in ANY BirrStack-org repo follow the §2.2 message format without exception.

### 2.7 CI Continuity (v3)
- GitHub Actions workflows: the classic PAT (if provided for workflow triggers) is used ONLY as a repository secret (e.g. `GH_PAT`) referenced as `${{ secrets.GH_PAT }}` — NEVER hardcoded in workflow files, and never in any committed file.
- Every push must leave CI able to pass: `npm run build` + `npm run test` locally BEFORE every push (§2.4 already mandates this).
- A red CI run on the default branch is a P0 violation: fix-forward immediately in the next commit; never leave the default branch broken.

### 2.8 Gradle/Toolchain Reality Check (v3)
- Native toolchains that cannot run in the current sandbox (Android SDK, Xcode, Visual Studio) MUST be exercised in CI (GitHub Actions with `android` runner images) before any "builds on device" claim is made. Locally, only code-level and generator-level verification is claimed — no more, no less (Amanah, §1).

### 2.9 Regression Guard (v4 — HARD GATE)
- The test count of any package may **never decrease** between commits. A feature removal or refactor that deletes tests must replace them with equivalent-or-better coverage in the SAME commit.
- A feature marked DONE in `FEATURES.md` may never be silently downgraded; a downgrade requires a worklog entry stating the reason and the recovery plan.
- If `npm run build` or `npm run test` fails at any point, the agent MUST fix forward before any other work — no parking broken state.

### 2.10 Session Boot Sequence (v4 — EXACT ORDER)
Every session on any BirrStack-org repo MUST run, in order, nothing skipped:
1. §0 adhkar (full, before the first tool call — nothing before it).
2. Clean workspace audit; remove scaffolds not part of the target repo.
3. Clone (or enter) the target repo; verify default branch (`git branch --show-current`) matches the remote default.
4. Protocol check: `Core_Working_Protocol.md` must exist and be the current STRICT edition; strengthen if stale (a stale copy is a violation).
5. `git pull --rebase origin <default>`; run `npm install && npm run build && npm run test` to establish the green baseline.
6. Read `WORKLOG.md` (repo) + `/home/z/my-project/worklog.md` (shared).
7. Read `FEATURES.md` ledger; audit DONE/PARTIAL/PLANNED honestly.
8. Produce the session TODO (granular sub-sub-tasks), then implement with §2.4 cadence.

### 2.11 Live Deployment Battle-Test Protocol (v5 — REQUIRED FOR ANY "LIVE" CLAIM)
- An app may be called **deployed/live** only after ALL of these are verified against the real production URL (not localhost, not preview):
  1. The deployed URL returns HTTP 200 for the home route and for every key public route.
  2. The served HTML contains real pre-rendered content (server-rendered text present in the HTML source — checkable with a plain HTTP GET, no JS execution). Skeleton-only HTML is a FAIL.
  3. `robots.txt`, `sitemap.xml`, and a branded 404 page are live and correct.
  4. **Zero-Worker proof:** the deployed Pages project contains NO `_worker.js`, NO `functions/` directory, and the deploy log shows no Functions bundled. Cloudflare request-time compute quota consumed: ZERO. Verify via the CF API or dashboard, and record the evidence in the worklog.
  5. **No-credential-baking proof:** the served JS bundles are grepped for every secret value used in the project (DB keys, admin tokens, CF tokens). Any hit is a P0 violation (§3.8).
  6. Critical journeys are exercised on the live URL (navigation, data loading from the BaaS, form validation, auth flow where present) via the emulator harness with a real-HTTP driver or via Agent Browser — and results recorded honestly.
  7. **Live-contract proof (v6):** a deploy path (e.g. `birr deploy cloudflare`) may be called "working" only after at least one REAL deployment has succeeded against the production host API and the live URL has passed items 1–6. Fake/simulated transports prove unit behavior only — never the contract (Amanah, §1.2).
- Re-verification is required after every material change to the app or its data layer. A stale "live" claim is a breach of Amanah (§1).

### 2.12 Divergence, Mode-Noise & Force-Push Safety (v6 — HARD GATE)
- Before EVERY push: `git fetch origin` first. If local and remote have diverged (ahead AND behind > 0), NEVER force-push the default branch. Safeguard local work first: commit it with a protocol-compliant message, then `git rebase origin/<default>` (on protocol/docs conflicts, resolve to the UNION — the stricter combination of both versions), then push, then verify the hash (§2.3).
- Mode-only changes (permission-bit churn: files modified with 0 insertions AND 0 deletions) MUST be discarded (`git checkout -- .`) before committing, unless the permission change is the deliberate content of the task. A commit whose numstat is all-zero across many files is a violation.
- `git reset --hard origin/<default>` is FORBIDDEN while any unpushed local commit exists — the §2.4 cadence exists precisely to make that situation impossible. Safeguard before any destructive operation.

---


### 2.13 Specs-vs-Implementation Audit Doctrine (v7 — BINDING)
- Every app repo that carries a specs document MUST be fully audited: each spec item is mapped to its implementation status — DONE (with evidence: file paths + tests), PARTIAL (what exactly is missing), or MISSING. The audit is written into the repo (e.g. `AUDIT-<date>.md`) in the SAME work unit the gaps are closed.
- Closing gaps means shipping REAL production code — no stubs, no mocks, no TODO placeholders (§1). The audit is complete only when every spec item is DONE or the spec itself is formally amended with the owner's consent.
- For Teaching Aids and BirrPubs this audit is a current-cycle REQUIREMENT, followed by Lughoh and the Qur'an-Hadith web rebuild.

### 2.14 Token Roster & Scope Discipline (v8 — BINDING)
- The session's credentials are issued per scope and MUST be used only for their stated purpose. The roster is maintained HERE (names + scopes only — never values, never in any file the repo tracks):
  1. **Web-repos GitHub token** — only: BirrStack, Birr-Teachers-Teaching-Aids-Beta-, BirrPubs-Beta, Lughoh-BirrJS, Qur'an-Hadith repos (clone/push/release).
  2. **Native-workflow GitHub token** — only: MuslimOS-Beta and native-release operations.
  3. **Cloudflare API token** — only: Pages project deploy hooks, project settings/env reads, zero-Worker consumption audits. Passed to tooling via environment variable in the SAME command chain only (§3.6A); never written to any file, script, or log.
  4. **npm publish token** — only: publishing `@birrstack/*` packages; supplied at publish time via environment variable; never committed.
  5. **Lightbase battle-lab key** — only: seeding/verifying `battle-lab` collections; admin keys never enter app repos or bundles (§3.8).
- A credential used outside its scope is a P0 incident (treat as compromised; rotate via owner; note in worklog).
- Values MUST never appear in: committed files, `.git/config` URLs, shell history echoes, worklogs, commit messages, or CI YAML. The credential store file lives outside all repos at mode 600 (§3.6).

### 2.14A Live-Battle-Test Evidence Bundle (v8)
- Every "deployed and battle-tested" claim ships an evidence bundle recorded in the repo worklog: (1) route 200 matrix (every public route, real HTTP GET), (2) content-presence grep on served HTML source (server-rendered text, not skeleton), (3) zero-Worker artifact scan output (§4.10), (4) credential-baking grep output (§3.8), (5) journey transcript (steps + observed outcomes, §2A.6), (6) CF request-compute consumption evidence (§2.11 item 4). Claims without the bundle are PARTIAL by definition.

## 2A. Battle-Testing Protocol (MANDATORY FOR "PRODUCTION" CLAIMS)
An app or feature may only be called production-ready when ALL of the following pass:
1. **Build gate:** `npm run build` succeeds with zero errors.
2. **Unit/integration gate:** full test suite green (`npm test`).
3. **Emulator gate:** the app boots in the BirrStack emulator for the target platform profile (android/web minimum) and the critical user journeys are exercised — not just rendered.
4. **Security gate:** no secrets in diff, no eval on untrusted input, inputs validated at boundaries, deny-by-default enforced on new IPC/routes.
5. **Honesty gate:** anything NOT tested is documented as untested in the worklog. Never claim what was not verified.
6. **Emulator specificity (v3):** "exercised" means each critical journey is scripted and asserted: tap targets produce state changes, lists render data (not skeletons), navigation completes both directions, forms validate invalid input, and the app recovers from process death. A journey that cannot be scripted yet is listed untested in the worklog — the emulator harness grows until no journey is unscriptable.
7. **App-repo battle cadence (v4):** every app repo carries a `journeys/` directory of scripted journeys run in CI on every push; a release is cut ONLY from a commit whose journeys all pass (§2.5).

---

## 3. Security Guardrails (Production-Grade)

### 3.1 Input Validation
- All external input (HTTP, IPC, user events, DB queries) MUST be validated at the boundary using a schema validator (Zod or BirrStack built-in `birr/validate`).
- No `eval`, no `new Function()` on untrusted input, no `innerHTML` without sanitization.

### 3.2 Authentication & Authorization
- Sessions: signed, httpOnly, secure, sameSite=strict cookies. Token rotation on privilege change.
- Passwords: argon2id (preferred) or scrypt. Never bcrypt < cost 12. Never MD5/SHA1.
- Authorization: deny-by-default. Every route and IPC handler declares required capabilities.

### 3.2A Enterprise Auth Doctrine (v7 — BINDING)
- Every fleet platform that has user accounts MUST implement **normal, logical, enterprise-grade authentication** — real username/email + password login, password hashing on the server that stores them, issued sessions/tokens with expiry and rotation, role-based access control (public user / author / editor / platform-admin), protected dashboards, and clean logout — implemented **without violating the full-SSR + zero-CF-Worker doctrine (§5.5)**.
- Under zero-Worker constraints, the ONLY lawful auth architecture is: the BaaS (Lightbase) issues and validates sessions server-side; clients hold session tokens in httpOnly-style storage managed by the BirrStack auth package; ALL privileged operations execute under the authenticated session on the BaaS — never under any key baked into an artifact (§3.8, §5.5A).
- FORBIDDEN: hardcoded/backdoor admin credentials in code or data, magic default passwords, client-side-only "admin" checks, or auth flows that would require a Cloudflare Worker.
- Any auth claim ("login works", "RBAC enforced") is PARTIAL until battle-tested live (§2.11) with a real account creation → login → privileged action → logout cycle.

### 3.3 Dependency Hygiene
- `npm audit` must pass with zero high/critical vulnerabilities before each release.
- No `postinstall` scripts from unvetted dependencies.
- Lockfile (`npm-lock.yaml`) MUST be committed.

### 3.4 Data Protection
- PII encrypted at rest (AES-256-GCM). Keys in environment, never in code.
- SQL/NoSQL injection prevented via parameterized queries only — no string concatenation.
- CSP headers strict on all web targets. No `unsafe-inline` except where a nonce is used.

### 3.5 Native Target Hardening
- Android: `android:allowBackup="false"`, `android:debuggable="false"` on release, network security config pins the backend.
- Windows: code-signed binaries, ASLR + DEP enforced, no elevation requests unless required.
- All native shells: sandboxed WebView, JS bridge surface limited to a capability-allowlist.

### 3.6 Token & Secret Hygiene (v3)
- Git remote credentials live ONLY in `~/.git-credentials` (mode 600) or a per-invocation environment variable — NEVER in `.git/config` remote URLs, NEVER in committed files, NEVER echoed into logs or worklogs.
- If a token ever lands in a committed file: treat as compromised — stop, revoke/rotate via the owner, then purge from history (git filter-repo) and force-push per owner's instruction, with a worklog entry.
- Worklogs and commit messages MUST never contain secret material of any kind.

### 3.6A Sandbox Token-Persistence Rule (v6)
- In this sandbox, exported environment variables do NOT persist across separate shell invocations. Every command chain that performs an authenticated git operation (clone/fetch/push/ls-remote) MUST re-export the token inline at the start of that SAME command chain; the credential helper reads the token from the environment variable — never from a file inside any repository, never from `.git/config` remote URLs, never hardcoded anywhere that gets committed.
- Token-scope discipline: web-repo tokens are used ONLY for the repos they were issued for; native-workflow tokens only for native repos; Cloudflare/npm credentials only for their stated purpose. Mixing scopes is a violation. If a token ever lands in a committed artifact, execute §3.6 incident steps immediately.

### 3.8 BaaS / Lightbase Security Rules (v5 — for all apps on static hosting)
- Static-host apps have NO server to keep secrets. Therefore: ONLY public-scoped, read-only, rate-limit-aware data keys may ever reach a client bundle. Privileged operations (admin writes, user data mutations) go through authenticated sessions issued by the BaaS, never through baked tokens.
- **Credential-baking gate (hard):** before every deploy, grep the built output (`dist/`) for every secret value in scope (API keys with write/admin scope, service keys, tokens). ANY hit blocks the deploy. This gate is part of §2.11 item 5.
- Collection-level access rules on the BaaS MUST be deny-by-default: public collections are explicitly listed and read-only; everything else requires auth. No collection is world-writable.
- All input crossing the BaaS boundary is validated with a schema validator client-side AND constraint-checked by the BaaS schema (defense in depth, §3.1).
- Per-app namespace discipline: shared BaaS projects prefix collections per app (`ta_` Teaching Aids, `bp_` BirrPubs, `lg_` Lughoh) so data can be reseeded to dedicated projects without collision.

### 3.9 Sandbox Preview & Gateway Rules (v6)
- The sandbox exposes exactly ONE externally reachable port (3000) through a gateway. Users preview work ONLY via the Preview Panel (and "Open in New Tab"); agents MUST never instruct users to open `localhost`, `127.0.0.1`, or raw-port URLs.
- Frontend API/WebSocket requests MUST use relative paths only; requests to other local services go through the gateway with `?XTransformPort=<port>`. Absolute localhost URLs are forbidden in frontend code.
- After every coding batch, check the dev-server log (`/home/z/my-project/dev.log`, most recent lines) for runtime errors BEFORE claiming success — a green build is not proof of a working page; browser-level verification is required for user-facing claims (§2.11 item 6).

### 3.7 Supply-Chain & Commit Hygiene (v4)
- `package-lock.json` MUST be committed; CI installs use `npm ci`.
- `birrstack-core`, `birrstack-compiler`, `birrstack-db`, `birrstack-native` have ZERO runtime dependencies (devDependencies only). Adding a runtime dependency to these packages requires a worklog justification plus an honest bundle-size measurement (§4.7).
- No generated output (`dist/`, `ci-out/`, `node_modules/`) is ever committed.
- Before every push, self-review the diff: `git diff --stat origin/main..HEAD` must match the intended change — no accidental sweeps (node_modules, dist, secrets, editor configs).

---

## 4. Engineering Quality Standards

### 4.1 No Emojis in Icons or UI
- Iconography uses SVG (lucide, heroicons, or custom BirrStack icon set). Emojis are forbidden as UI icons.
- Rationale: inconsistent rendering across platforms, accessibility issues, unprofessional appearance.

### 4.2 Mobile-First, Native-App-Like UX
- All apps are designed mobile-first, then scaled up to tablet/desktop.
- Touch targets >= 44x44dp. Animations <= 300ms with `ease-out`. No jank (60fps target).
- Follow the BirrStack Design System (see `docs/design-system.md`).

### 4.3 Design System (Official Brand Palette)
| Token | Hex | Usage |
|-------|-----|-------|
| Primary Green | `#05B34D` | Primary actions, brand |
| Accent Gold | `#F2B91C` | Highlights, CTAs secondary |
| Dark | `#181F25` | Dark mode bg, text on light |
| Light Background | `#E9FBF1` | Light mode bg |
| Utility White | `#FFFFFF` | Surfaces, cards |

- Light mode is the default. Dark mode toggle in every header. Toggle persists per-device.
- Contrast ratios MUST meet WCAG AA (4.5:1 for body text).

### 4.4 Code Style
- TypeScript strict mode everywhere. No `any` without an inline justification comment.
- ESLint + Prettier enforced via pre-commit hook (husky + lint-staged).
- Function length <= 50 lines. Cyclomatic complexity <= 10. If exceeded, refactor.

### 4.5 Testing
- Unit tests for all pure functions (Vitest). Coverage >= 80% for framework core.
- Integration tests for all IPC/HTTP handlers.
- E2E tests (Playwright) for critical user journeys in each app.
- "Battle-tested" = tests exist, run green, and cover edge cases (empty, null, max-length, concurrent).

### 4.6 Feature-Completeness Ledger (v3)
- `FEATURES.md` at the repo root is the single source of truth for feature claims. Every feature the stack provides is listed with: status (PLANNED / IN PROGRESS / DONE), the package that provides it, and the test file(s) proving it.
- A feature without a green test proving it is listed IN PROGRESS, never DONE (Amanah, §1.2).
- "100x / 100+ features" goals are tracked numerically in FEATURES.md — count features, not marketing words.

### 4.7 Performance Budgets (v4 — measured, not aspirational)
- Runtime ESSENTIAL core (signals + DOM + component + router): ≤ 12KB gzipped.
- Runtime FULL dist (all opt-in core modules, tree-shakeable per app): ≤ 60KB gzipped (raised from 48KB when SSR v2 + the BaaS data layer landed — documented per §2.9; both are opt-in modules apps never importing them pay zero bytes for).
- A `birr create` hello-app production build: ≤ 6KB gzipped total JS (apps/demo is the tracked proxy).
- Every new core feature states its added-bytes cost in the commit body; a feature that breaches a budget needs explicit worklog justification.
- Budgets are verified by `node scripts/size-budget.mjs`; a breach is a failing gate, not a warning.

### 4.9 Static-Host Readiness Checklist (v5 — every app repo, verified before deploy)
- [ ] Every public route is pre-rendered (SSG) with real content, per-route title + meta description + Open Graph tags.
- [ ] `sitemap.xml` lists every public route; `robots.txt` correct; branded `404.html` present.
- [ ] Hydration bundle loads and takes over the pre-rendered DOM without a full re-render flash.
- [ ] CSP allows the app's BaaS origin(s) and nothing more (no wildcard connect-src).
- [ ] Size budgets pass (§4.7) for the app's bundles.
- [ ] Zero Worker artifacts in output: no `_worker.js`, no `functions/`, no serverless bundles.
- [ ] Credential-baking gate passes (§3.8).

### 4.10 Automated Zero-Worker & Credential Gates (v6 — HARD GATES, not checklists)
- The zero-Worker scan (no `_worker.js`, no `functions/`) and the credential-baking scan (no secret values in built output) MUST run as executable gates on every deploy path: `birr deploy` runs both on the exact artifact being uploaded, and CI runs a scan step on every build. A deploy performed without both gates having run and passed is a violation — hand-ticked checklist boxes do not count.
- Deploy contracts are proven live (§2.11 item 7). Until a REAL deployment has succeeded against the production API, the deploy path's status in `FEATURES.md` stays PARTIAL — no exceptions.

### 4.11 CSS Delivery Integrity Gate (v7 — HARD GATE)
- **No deployed route may ever render as raw HTML without its CSS.** For every HTML document in a deploy artifact, the artifact MUST contain the referenced stylesheet(s) at the exact paths referenced, and every page's rendered DOM must link them via `<link rel="stylesheet">` (or a correctly inlined critical CSS). A single route rendering unstyled is a deployment-BLOCKING defect.
- The gate runs mechanically on the exact artifact before upload (part of `birr deploy`), and in CI: parse every `.html` file, extract stylesheet refs, verify each target exists in the artifact and is non-empty. Fleet incident being remediated: BirrPubs, Qur'an-Hadith deploy, Teaching Aids deploy, and intermittently Lughoh rendered raw unstyled HTML — this gate exists so that class of defect can never ship again.
- A visual smoke check (screenshot/emulator, §2A) on at least the home route of each deployed app complements the mechanical gate — both must pass before "deployed" is claimed.

### 4.8 Documentation Currency (v4)
- `FEATURES.md` rows are added/updated in the SAME commit as the feature they describe — never in a later "docs sweep".
- `README.md` quick-start is verified by actually running it whenever build tooling changes.
- Every package exposes current usage docs; a package without usage docs is listed PARTIAL in FEATURES.md regardless of test status.

---

## 5. BirrStack Framework Architectural Decisions

### 5.1 Approach: From Scratch (NOT Astro-based)
**Decision:** BirrStack is built from scratch, not on top of Astro/Next/Nuxt.
**Rationale:**
- The goal is a framework lighter than all of them; building on Astro inherits its weight.
- A from-scratch core lets us optimize the runtime, the bundler pipeline, and the native bridge as one coherent system.
- We CAN use Vite (a build tool, not a framework) as the underlying dev server / bundler — this is not "building on Astro", it is using an industry-standard tool.

### 5.2 Core Principles
1. **Pure HTML/CSS/JS surface.** A developer who knows HTML/CSS/JS can build a full app. Zero learning curve. No JSX, no Svelte syntax, no new template language. Components are `.birr` files using standard HTML + a `<script>` + a `<style>` block (familiar to anyone who has seen a Vue SFC, but stricter and simpler).
2. **Single codebase, all platforms.** One BirrStack app runs on web, Android, iOS, Windows, macOS, Linux. The native shells are thin WebViews + a capability-bridged JS API.
3. **SPA by default.** Client-side routing with optional SSR/SSG opt-in.
4. **Modularity.** `birrstack/core`, `birrstack/db`, `birrstack/native`, `birrstack/auth`, `birrstack/ui` are independent packages. Use only what you need.
5. **Lightweight by construction.** No polyfills for dead browsers. Tree-shaking at the import level. Runtime core target: < 30KB gzipped.
6. **Batteries included, not imposed.** BirrDB ships in the box but can be swapped for Lightbase, SQLite, or any cloud DB via the adapter interface.

### 5.3 Package Structure
```
packages/
  birrstack-core/        # Runtime: reactivity, components, router, SSR
  birrstack-db/          # BirrDB: lightweight embedded DB, exportable
  birrstack-native/      # Native bridges: Android/iOS/Win/macOS/Linux
  birrstack-auth/        # Auth: sessions, argon2, RBAC, OAuth adapters
  birrstack-ui/          # UI kit: components styled per design system
  birrstack-cli/         # `birr` CLI: create, dev, build, export, emulate
  birrstack-emulator/    # Built-in multi-platform emulator (web-based)
  birrstack-export/      # Platform exporters: apk, exe, dmg, ipa, web
  birrstack-docs/        # Documentation site + guides
apps/                 # Apps built with BirrStack (the 5 apps)
docs/                 # Architecture, design system, guides
```

### 5.5 ADR: Cloudflare Pages Zero-Worker Deployment Doctrine (v5 — BINDING)
**Decision:** BirrStack apps deploy to Cloudflare Pages with FULL server-rendered content and FULLY functional dynamic behavior while consuming **ZERO Cloudflare Workers/Functions quota**. Workers, Pages Functions, `_worker.js`, and `functions/` are FORBIDDEN in all deployed BirrStack apps.
**How (the honest architecture):**
1. **Build-time SSR is real SSR.** Every public route is rendered by `renderToString`/`renderToStringAsync` at BUILD time on the developer/CI machine (or in GitHub Actions) and shipped as static HTML. The HTML source contains the full content — crawlable, SEO-complete, instant first paint. This is the same model Astro uses for its static output.
2. **Runtime is hydration + BaaS.** The client bundle hydrates the pre-rendered DOM; dynamic data flows through the BirrStack data layer (§5.6) to a BaaS (Lightbase) using public-scoped keys. Forms, auth, dashboards, realtime — all work, with zero request-time compute on Cloudflare.
3. **Content freshness:** content changes trigger a rebuild/redeploy (Git-integration or deploy hook), not request-time rendering. An ISR-like rebuild path is provided via CI.
4. **Escape hatch to full request-time SSR (other platforms):** BirrStack provides a Node SSR adapter (`birr serve`) for hosts that allow servers (Node/Bun/Render/Fly). The SAME codebase renders on-demand there. Static hosts get build-time SSR; server hosts get on-demand SSR. No code changes.
**Forbidden:** shipping `_worker.js`, `functions/`, or any Pages Function; baking ANY secret into client bundles; describing SSG-less SPA shells as "SSR".
**Honesty note (§1):** on static hosts, "SSR" means build-time server rendering (content present in HTML source). Request-time SSR exists only on the Node adapter path. Claims must state which one they mean.

### 5.5A Env Contract & .env.example Doctrine (v7 — BINDING, completes the no-baking doctrine)
1. **Single source of truth:** ALL environment variables for every deployed fleet platform (BirrPubs, Teaching Aids, Lughoh, Qur'an-Hadith web, and every future app) live in the **Cloudflare Pages deployment settings UI** (Project → Settings → Environment variables & Secrets). They are editable ANYTIME from that UI and take effect on the next build. No env value may live anywhere else.
2. **Zero baking, absolute:** no credential, no key, no token, no secret value may appear in source code, static assets, docs, commit messages, or product copy. The CLI reads the project's env FROM the CF Pages settings (via API, names-only display) and injects it at build time — values flow from the UI through the build into the artifact's server-side-config surface, never from the repo.
3. **Dishonest copy is a defect:** any text claiming credentials are handled in a way they are not — e.g. "Content management runs on your Lightbase API key — verified by Lightbase itself (this static site never stores credentials)" — is a FLAGGED DEFECT, not a feature. The only honest copy describes exactly where env values are configured (CF Pages settings UI) and how they are consumed (build-time injection via the CLI env contract). Any agent finding such copy must remove/rewrite it in the same work unit.
4. **`.env.example` is mandatory in EVERY repo** (framework AND apps): it documents the COMPLETE env contract — every variable NAME, its purpose, an example placeholder value (never a real value), scope (build-time/runtime/client-safe), and the exact place to set it (Cloudflare Pages → Settings → Environment variables). A repo without a current `.env.example` fails the §7 checklist.
5. **UI-first verification:** before declaring an app's env contract complete, the agent must confirm via the Cloudflare API that every variable named in `.env.example` exists in the Pages project settings UI for that platform — and report any secret-typed entries honestly as names-only (unreadable by API by design, never "invented").

### 5.5C No-External-Compute Doctrine (v9 — BINDING, supersedes any contradicting reading of §5.5B where they conflict)
1. **Owner directive (recorded):** NO operator-provided external machines (no VPS, no PaaS render origin, no always-on compute), AND NO BaaS edge/app-compute (no Lightbase edge functions, no SSR bridge/gateway — the patterns used by Researchful, Prodesign and Kaatibai are explicitly forbidden for BirrStack platforms). All deployments run on Cloudflare Pages with zero CF Workers.
2. **The lawful compute set is exactly three planes:** (a) build-time CI — compile/render public HTML; (b) the BaaS DATA PLANE — auth token issuance, collections CRUD under rules, storage, change feed/realtime subscriptions, aggregations/search, and writes from trusted SERVICE PRINCIPALS (e.g. payment gateways) — it stores and guards truth but NEVER executes app logic; (c) the client device — ALL app logic (rendering per navigation, orchestration, validation, AI calls under the key-delivery doctrine, WASM export/analytics pipelines, offline outbox, local reactive store).
3. **Class B (Live SSR on an external origin) is RETIRED as a deployment class.** `birr serve` remains a development/preview tool (localhost) only — never a production deployment. Every deployment claim states its class as A or C (per ADR-002) plus its class map per surface. Claiming an external origin or edge-function deployment for a BirrStack platform is a P0 violation.
4. **Key-delivery doctrine:** platform/provider secret keys are NEVER shipped in any artifact and NEVER delivered to the browser. AI features run on the BYOK / user-scoped key model — a user's own key, encrypted at rest in the BaaS, delivered only over their authenticated session, used by their own device. Multi-tenant proxying of platform-owned model keys requires trusted request-time compute and is therefore OUT OF SCOPE under §5.5C — declared honestly, never faked.
5. **Payments/authoritative third parties:** webhook receivers (our own endpoints executing verification logic) are forbidden app-compute. The lawful pattern: the trusted third party is a service principal writing to the data plane, and/or the client uses the third party's public verification tokens with pull-verify; fulfillment is rules-guarded entitlement state the client consumes reactively.
6. **Honest impossibility rule:** anything genuinely requiring external request-time compute (CORS-blocked scraping, outbound email as app logic, platform-key proxying) is stated as an impossibility with its lawful replacement (client-direct where CORS permits, mail/principal services, BYOK) — never faked, never silently dropped (Amanah, §1).

### 5.5B Compute-Honesty Doctrine (v8 — BINDING, supersedes any contradicting reading of §5.5)
1. **Physical truth:** real-time (request-time) SSR requires request-time compute. On Cloudflare, ALL request-time compute is Workers — Pages Functions, `_worker.js`, and `_worker.js/advanced mode` are all Workers under the hood. Therefore the triple "Cloudflare Pages hosting + real-time SSR + zero Worker quota" is **physically impossible** on the current Cloudflare platform. No agent may claim it, fake it, ship a simulation of it, or reword §5.5 to imply it (Amanah, §1).
2. **Two first-class deployment classes** — BirrStack supports BOTH from the SAME codebase, and every deployment claim states its class explicitly:
   - **Class A — Zero-Compute Web** (Cloudflare Pages and any static host): build-time server-rendered HTML for public routes (full content in HTML source), hydration island, live dynamic behavior through the BaaS (public reads + session-authenticated writes; forms, auth, dashboards, search, realtime all functional). Request-time compute on the host: ZERO. This is the default Cloudflare target.
   - **Class B — Live SSR** (any host with compute: Node/Bun/Deno adapters, self-hosted VPS, PaaS free tiers, or the org's own backend): true on-demand `renderToString`/streaming per request with server-side sessions, cookies, and headers. `birr serve` is the reference adapter; the framework MUST keep this path production-grade — never second-class.
3. **Parity contract:** app code builds to both classes without forking the codebase. A feature that fundamentally needs request-time compute must either (a) move its compute to the BaaS (the Class A way), or (b) be declared Class-B-only in FEATURES.md. Faking Class-B behavior on Class A (e.g. client-side fetch masquerading as "server rendering", or pre-rendered HTML described as "real-time SSR") is a P0 violation.
4. **Labeling:** every README, deploy log, FEATURES.md row, and commit that touches deployment states which class it is. "SSR" without a class qualifier is a forbidden ambiguous term in committed docs.

### 5.6 Lightbase Battle-Lab Policy (v5)
- ONE shared Lightbase project (`battle-lab`) serves BirrPubs, Teaching Aids, and Lughoh for battle testing until each receives a dedicated project.
- Collections are namespaced per app (§3.8): `ta_*`, `bp_*`, `lg_*`. Data seeds are organized so a later switch to dedicated projects is a config change + reseed, not a rewrite.
- Connection config comes from environment/build-time PUBLIC config (project id + public key only). Admin/service keys never enter app repos or bundles (§3.6, §3.8).

### 5.4 BirrDB Design Targets
- Embedded, zero-dependency, runs in browser (via WASM/OPFS) and Node/Bun/native.
- Columnar storage with dictionary compression + delta encoding. Target: 100GB SQLite-equivalent data in < 10GB (the user's spec said <10MB for 100GB which is aspirational; we target a 10x reduction as the honest engineering goal, and push further where data permits).
- Realtime subscription via a tiny pub/sub layer (works locally and syncs to cloud when online).
- Exportable as a standalone npm package (`@birrstack/db`) usable outside BirrStack apps.
- Adapter interface for one-click migration to Lightbase, Firebase, Supabase, Postgres.

---

## 6. Worklog Protocol

All agents share a single worklog at `/home/z/my-project/worklog.md` (and a mirror in each repo at `WORKLOG.md`). Every agent:
1. Reads the worklog before starting work.
2. Appends a new section after completing its task (never overwrites).
3. Uses the format defined in the project root README.

### 6B. Sub-Agent Delegation Rules (v4)
- Sub-agents receive: their Task ID, the exact file/directory scope they may touch, the shared worklog path, and the explicit rule that they do **NOT** run `git add/commit/push` — the coordinator integrates, gates, commits, and pushes.
- Sub-agent outputs are UNTRUSTED until the coordinator runs the full gates (build + tests) on the integrated tree (Amanah §1.2 applies to borrowed work too).
- Sub-agents MUST follow §0 adhkar and append their worklog section using the standard template.
- If a sub-agent times out, the coordinator completes the task in the main thread and notes it in the worklog — the task is never silently dropped.

### 6C. Task-ID Scheme & Worklog Immutability (v6)
- Task IDs are globally ordered with optional parallelism: `1`, `2-a`, `2-b`, `3`, … Every sub-agent prompt MUST state: its Task ID, the shared worklog path (`/home/z/my-project/worklog.md`), the read-before-work / append-after-work rule, the no-git rule (the coordinator integrates, gates, commits, pushes), and the §0 adhkar obligation (full, before the first tool call — including in the sub-agent's internal reasoning).
- The shared worklog is APPEND-ONLY: agents never modify or delete other agents' entries; corrections are made by appending a new dated note. The template (Task ID / Agent / Task / Work Log / Stage Summary) is mandatory in every entry.

### 6D. Session Close-out & Remaining-Work Ledger (v8 — BINDING)
- A session MUST NOT end silently. Before the final adhkar, the agent appends to the shared worklog AND the repo WORKLOG a **Remaining Work** section listing: every incomplete task with its Task ID, its exact next concrete step, and any blocking constraint. "Completed what I could" is an incomplete close-out.
- If a scope item from the owner's directive was not started, it MUST appear in the ledger — silence is dishonesty (§1.3).
- The close-out MUST end with: green build + green tests on the last pushed commit, the verified push hash (§2.3), and the full adhkar.

## 6A. Agent Handover Protocol (v3)
- Before starting ANY task, the agent MUST: (1) recite the §0 adhkar, (2) read `/home/z/my-project/worklog.md`, (3) read the target repo's `WORKLOG.md`, (4) `git pull --rebase` the default branch.
- Sub-agents receive: their Task ID, the path to the shared worklog, and the explicit instruction to read-before-work and append-after-work with the template (Task ID / Agent / Task / Work Log / Stage Summary).
- A session that ends MUST leave: green build, green tests, all work committed+pushed with hash verified, worklog updated. An agent that cannot finish cleanly states exactly what is incomplete in the worklog — no silent truncation.

---

## 7. Protocol Compliance Checklist (Run Before Every Commit)

- [ ] Opening adhkar recited (internally) before starting this work unit
- [ ] Work is production-grade (no dummies, no mocks without labeling)
- [ ] Build passes (`npm build`)
- [ ] Tests written and green for new functionality
- [ ] No secrets in diff
- [ ] Worktree free of mode-only noise; divergence checked (`git fetch` + rebase) before push (§2.12)
- [ ] If deploy-related: zero-Worker + credential gates ran and passed on the exact artifact (§4.10); CSS Delivery Integrity gate passed (§4.11); deployment class stated explicitly (Class A Zero-Compute / Class B Live SSR, §5.5B)
- [ ] Env contract current: `.env.example` matches the app's real env needs; CF Pages settings UI holds the complete env for the platform (§5.5A)
- [ ] No dishonest credential copy anywhere in the diff (§5.5A item 3)
- [ ] Commit message starts and ends with Core Working Protocol markers
- [ ] Pushed to `origin/<default>` and hash verified; token used within its §2.14 scope
- [ ] Worklog updated; if session ends, Remaining Work ledger written (§6D)
- [ ] Closing adhkar recited

---

## 8. Violation Handling

If an agent discovers it has violated this protocol (e.g., committed without the markers, pushed without verifying the hash, merged a stub without labeling):
1. Stop. Recite the opening adhkar.
2. Fix the violation immediately (amend commit, re-push, label the stub).
3. Note the violation and the fix in the worklog.
4. Do not hide the violation. Transparency is part of Amanah.

---

*BismiLLAH Ar-Rahman Ar-Raheem. This protocol is the root; the work is the tree. May ALLAH Azzawajal put barakah in this effort.*
