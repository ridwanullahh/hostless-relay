#!/usr/bin/env bash
# Hostless ops runner — fleet API backend split. BismiLLAH.
# Credentials arrive via GitHub Secrets ONLY. Values are never printed.
set -uo pipefail

say() { echo "[hostless-ops] $*"; }
die() { echo "[hostless-ops][FATAL] $*" >&2; exit 1; }

for c in hostless git jq curl; do command -v "$c" >/dev/null || die "missing tool: $c"; done
[ -n "${HOSTLESS_TOKEN:-}" ] || die "HOSTLESS_TOKEN secret missing"

SUM="${GITHUB_STEP_SUMMARY:-/dev/null}"

app_env_payload() { # echo gzip+base64 payload of $APP from FLEET_ENVS json
  [ -n "${APP:-}" ] || return 1
  printf '%s' "${FLEET_ENVS:-}" | jq -r --arg app "$APP" '.[$app] // ""'
}

decode_env_payload() { # b64 -> gunzip -> K=V lines on stdout
  printf '%s' "$1" | base64 -d 2>/dev/null | gunzip -c 2>/dev/null
}

mask_env_payload() { # decode payload, mask every value
  local pay; pay=$(app_env_payload || true)
  [ -n "$pay" ] || return 0
  decode_env_payload "$pay" | while IFS= read -r line; do
    case "$line" in ''|\#*) continue;; esac
    v="${line#*=}"
    [ -n "$v" ] && echo "::add-mask::$v"
  done
}

write_result() { # $1 op  $2 payload-file
  local ts op payload out
  ts=$(date -u +%Y%m%d-%H%M%S); op="$1"; payload="$2"
  out="results/${ts}-${op}${APP:+-$APP}.json"
  mkdir -p results
  { echo "{ \"ts\":\"$ts\", \"op\":\"$op\", \"app\":\"${APP:-}\", \"result\": "; cat "$payload"; echo " }"; } > "$out" 2>/dev/null || cp "$payload" "$out"
  git config user.email "fleet-ops@birrstack.local"; git config user.name "fleet-ops"
  git remote set-url origin "https://x-access-token:${GH_PAT}@github.com/ridwanullahh/hostless-relay.git"
  git add results >/dev/null 2>&1 || true
  git commit -m "hostless-ops result: ${op} ${APP:-}" >/dev/null 2>&1 || true
  git push origin HEAD >/dev/null 2>&1 || true
  git remote set-url origin "https://github.com/ridwanullahh/hostless-relay.git"
  say "result committed: $out"
}

clone_repo() {
  [ -n "${REPO:-}" ] || die "repo input required for $OP"
  [ -n "${GH_PAT:-}" ] || die "GH_PAT secret missing"
  rm -rf workclone
  git clone --depth 1 --branch "${BRANCH:-main}" "https://x-access-token:${GH_PAT}@github.com/${REPO}.git" workclone || die "clone failed: $REPO@$BRANCH"
  git -C workclone remote set-url origin "https://github.com/${REPO}.git"
}

case "$OP" in
  list)
    say "listing projects and apps"
    hostless list projects --json > /tmp/r1.json 2>/tmp/r1.err || true
    hostless list apps --json > /tmp/r2.json 2>/tmp/r2.err || true
    cat /tmp/r1.json /tmp/r2.json 2>/dev/null | head -c 6000; echo
    { echo '{"projects":'; cat /tmp/r1.json 2>/dev/null || echo '[]'; echo ',"apps":'; cat /tmp/r2.json 2>/dev/null || echo '[]'; echo '}'; } > /tmp/rp.json 2>/dev/null || echo '{"note":"merge failed"}' > /tmp/rp.json
    write_result list /tmp/rp.json
    ;;

  create)
    mask_env_payload
    clone_repo
    # ensure the project exists (CLI only auto-creates when NO project exists at all)
    hostless create project "$PROJECT" -y 2>&1 | tail -3 || true
    cd workclone
    say "creating app $APP in project $PROJECT from ${REPO}@${BRANCH:-main} workdir=${WORKDIR:-server}"
    if hostless create app "$APP" --project "$PROJECT" --wait -y 2>&1 | tail -40; then
      echo "### created $APP" >> "$SUM"
      hostless info app "$APP" --project "$PROJECT" --json > /tmp/ri.json 2>/dev/null || true
      head -c 4000 /tmp/ri.json 2>/dev/null; echo
      if [ ! -s /tmp/ri.json ]; then
        echo "### create produced no app info — treating as failure" >> "$SUM"
        cd ..; write_result create /dev/null; die "create failed for $APP"
      fi
    else
      echo "### create failed for $APP (see logs above)" >> "$SUM"
      cd ..; write_result create /dev/null; die "create failed for $APP"
    fi
    cd ..; write_result create /tmp/ri.json
    ;;

  env-set)
    mask_env_payload
    [ -n "${APP:-}" ] || die "app required"
    PAY=$(app_env_payload) || die "secret FLEET_ENVS missing"
    [ -n "$PAY" ] || die "no env payload for $APP in FLEET_ENVS"
    umask 077; TMPENV=$(mktemp); decode_env_payload "$PAY" > "$TMPENV"
    mapfile -t PAIRS < <(grep -vE '^\s*(#|$)' "$TMPENV")
    rm -f "$TMPENV"
    say "setting ${#PAIRS[@]} env vars on $APP (values masked)"
    hostless env set "${PAIRS[@]}" --app "$APP" --project "$PROJECT" --deploy 2>&1 | tail -20
    hostless env list --app "$APP" --project "$PROJECT" 2>&1 | tail -60
    hostless list apps --json > /tmp/r2.json 2>/dev/null || echo '{}' > /tmp/r2.json
    write_result env-set /tmp/r2.json
    ;;

  deploy)
    mask_env_payload
    clone_repo
    cd workclone
    SHA=$(git rev-parse HEAD); say "deploying ${REPO}@${SHA} to $APP"
    if hostless deploy --wait --app "$APP" --project "$PROJECT" 2>&1 | tail -60; then
      echo "### deploy ok $APP @ $SHA" >> "$SUM"
    else
      echo "### deploy FAILED $APP @ $SHA" >> "$SUM"
    fi
    hostless info app "$APP" --project "$PROJECT" --json > /tmp/ri.json 2>/dev/null || true
    cd ..; write_result deploy /tmp/ri.json
    ;;

  info)
    hostless info app "$APP" --project "$PROJECT" --json 2>&1 | head -c 6000; echo
    hostless info app "$APP" --project "$PROJECT" --json > /tmp/ri.json 2>/dev/null || true
    write_result info /tmp/ri.json
    ;;

  api-call)
    # raw Hostless REST probe: API_METHOD/API_PATH/API_BODY via workflow inputs
    M="${API_METHOD:-GET}"; P="${API_PATH:-/v1}"; B="${API_BODY:-}"
    APIB="https://api.hostless.cloud"
    if [ "$M" = "GET" ]; then
      curl -s -H "Authorization: Bearer $HOSTLESS_TOKEN" -H "Content-Type: application/json" "$APIB$P" > /tmp/api.json 2>&1 || true
    else
      curl -s -X "$M" -H "Authorization: Bearer $HOSTLESS_TOKEN" -H "Content-Type: application/json" -d "${BODY64:+$(printf '%s' "$BODY64" | base64 -d 2>/dev/null)}" "$APIB$P" > /tmp/api.json 2>&1 || true
    fi
    head -c 6000 /tmp/api.json; echo
    write_result api-call /tmp/api.json
    ;;

  *)
    die "unknown op: $OP (list|create|env-set|deploy|info|api-call)"
    ;;
esac

say "done op=$OP app=${APP:-}"
