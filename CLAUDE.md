# Always-On Ops Agent

Synthetic enterprise repo used to demo an autonomous ops agent. Two Claude Code routines watch for production incidents and vendor compliance drift, triage them, and open GitHub issues automatically.

## What's here

| Path | Purpose |
|---|---|
| `issues/*.json` | Production incidents — the incident-triage routine reads these |
| `contracts/*.md` | Vendor contracts — the compliance-drift routine scans these |
| `runbooks/*.md` | Operational playbooks the triage routine references |
| `deploys/recent.json` | Recent deploy log for deploy correlation |
| `compliance-policy.md` | Policy the compliance routine enforces |
| `agent-state/processed.json` | Dedup state — tracks what each routine has already handled |
| `violations/*.md` | Compliance findings written by the compliance routine |
| `routines/incident-triage.md` | Full prompt for the incident-triage routine |
| `routines/compliance-drift.md` | Full prompt for the compliance-drift routine |

## Starting a new session

Run both routines as cron jobs:

```
Use CronCreate twice:

Job 1 — incident-triage (every 2 minutes — fast response to new issues):
  cron: "*/2 * * * *"
  recurring: true
  durable: true
  prompt: (paste full contents of routines/incident-triage.md, prefixed with:)
    "Your working directory is /Users/Season_Yang/Development/Training/always-on-agent.
     After all steps, run: git -C /Users/Season_Yang/Development/Training/always-on-agent push"

Job 2 — compliance-drift (every 10 minutes — contracts change slowly):
  cron: "5-59/10 * * * *"
  recurring: true
  durable: true
  prompt: (paste full contents of routines/compliance-drift.md, prefixed with:)
    "Your working directory is /Users/Season_Yang/Development/Training/always-on-agent.
     After all steps, run: git -C /Users/Season_Yang/Development/Training/always-on-agent push"
```

Or just say: **"restart the always-on-agent routines"** and Claude will do it.

## Stopping the routines

```
/cron list                    ← find the job IDs
/cron delete <job-id>         ← delete each one
```

Or say: **"stop the always-on-agent routines"**

## Demo playbook

**Trigger incident triage:**
```bash
cp issues/PROD-4487.json issues/PROD-9001.json
# Edit PROD-9001.json: change "id" to "PROD-9001"
git add issues/PROD-9001.json && git commit -m "demo: new incident" && git push
# Within 2 minutes: triage block appears in the JSON + GitHub issue opens
```

**Trigger compliance scan:**
```bash
# Touch any contract file to change its hash
echo "" >> contracts/acme-data-platform.md
git add contracts/acme-data-platform.md && git commit -m "demo: trigger compliance scan" && git push
# Within 10 minutes: violations/acme-data-platform.md written + GitHub issue opens
```

**Reset state (re-run everything from scratch):**
```bash
echo '{"incidents": {}, "compliance": {}}' > agent-state/processed.json
git add agent-state/processed.json && git commit -m "chore: reset agent state" && git push
```

## GitHub setup

- Repo: `xxSeasonxx/always-on-agent` (personal account)
- Remote uses SSH alias: `git@github.com-personal:xxSeasonxx/always-on-agent.git`
- Switch gh CLI before any `gh` commands: `gh auth switch --user xxSeasonxx`
- Labels already created: `incident`, `P0`, `P1`, `P2`, `P3`, `compliance`
