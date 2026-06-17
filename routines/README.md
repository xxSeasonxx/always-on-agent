# Always-On Ops Agent — Routines Setup

Two Claude Code routines that autonomously triage incidents and scan vendor contracts for compliance drift.

## Files

| File | Purpose |
|---|---|
| `incident-triage.md` | Routine prompt — paste into Claude Code Routines UI |
| `compliance-drift.md` | Routine prompt — paste into Claude Code Routines UI |
| `setup-labels.sh` | One-time script to create GitHub labels |

## One-time setup

```bash
# 1. Create GitHub labels
bash routines/setup-labels.sh

# 2. Push the repo (agent-state/ and violations/ directories need to exist)
git push
```

## Register routines in Claude Code

For each routine, go to the Claude Code Routines UI and create a new routine:

### Routine 1: Incident Triage

- **Name:** `incident-triage`
- **Prompt:** paste the full contents of `routines/incident-triage.md`
- **Trigger:** Push event — file pattern `issues/*.json`
- **Environment variable:** `GITHUB_TOKEN` = your GitHub personal access token (needs `repo` scope)

### Routine 2: Compliance Drift

- **Name:** `compliance-drift`
- **Prompt:** paste the full contents of `routines/compliance-drift.md`
- **Trigger:** Push event — file pattern `contracts/*.md` (also add `compliance-policy.md`)
- **Environment variable:** `GITHUB_TOKEN` = same token as above

## Demo playbook

**Trigger incident triage:**
```bash
# Copy an existing issue with a new ID
cp issues/PROD-4487.json issues/PROD-4999.json
# Edit to give it a new ID: change "id": "PROD-4487" → "id": "PROD-4999"
git add issues/PROD-4999.json
git commit -m "chore: add synthetic incident PROD-4999"
git push
# Watch the routine fire → GitHub issue appears, issues/PROD-4999.json gains a triage block
```

**Trigger compliance scan:**
```bash
# Amend a contract to introduce a violation (e.g., change breach notification window)
# Or just touch/re-save a contract file to change its hash
git add contracts/acme-data-platform.md
git commit -m "chore: trigger compliance re-scan"
git push
# Watch the routine fire → violations/acme-data-platform.md written, GitHub issue opened
```

**Verify no duplicates:**
```bash
# Push the same file again without changing its content
# Both routines should skip processing (state file prevents reprocessing)
```
