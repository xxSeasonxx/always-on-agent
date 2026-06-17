## Context

Synthetic enterprise repo used as a hackathon demo environment. The repo contains production incidents (`issues/`), runbooks, deploy history, and vendor contracts. Two Claude Code routines run autonomously: one triages incidents, one scans contracts for compliance drift. Both are triggered by push events and write results back to the repo while opening GitHub issues.

## Goals / Non-Goals

**Goals:**
- Automated incident triage with deploy correlation and runbook lookup, producing a severity rating and recommended actions
- Automated compliance drift detection across all vendor contracts against a central policy
- GitHub issues as the primary external output — visible, structured, actionable
- Deduplication via `agent-state/processed.json` so re-runs don't create duplicate GitHub issues

**Non-Goals:**
- Email notifications
- Cron scheduling (push trigger only for demo)
- Auto-remediation (recommendations only, no rollbacks executed)
- Slack or other notification channels

## Decisions

### Two routines, not one
Each routine has a single purpose and fails independently. Incidents are time-sensitive; compliance is not. Keeping them separate makes each easier to reason about and demo independently.

*Alternative considered*: Single monolithic routine. Rejected — a compliance scan failure would block incident triage, and the scheduling cadences differ.

### Push trigger only (no cron)
For a hackathon demo, the push trigger gives ~1 minute latency from file drop to triage. A cron would add up to 10 minutes of dead time during a live demo. Cron can be added post-demo as a safety net.

### State file for deduplication (`agent-state/processed.json`)
A single file read at startup tells each routine what's been handled. Two namespaces (`incidents`, `compliance`) prevent cross-routine interference.

*Alternative considered*: Checking for a `triage` block in the issue JSON itself. Rejected — requires reading every issue file on every run; state file is a single read.

### Hash-based reprocessing for contracts
Compliance routine stores a content hash per contract. A changed hash means the contract was amended and needs re-scanning. This lets the routine automatically re-evaluate when a vendor updates their contract terms.

### `gh` CLI for GitHub issues
Available in all GitHub environments, no additional dependencies. `gh issue list --search` provides sufficient dedup checking for demo scale.

### Rich triage reasoning in prompt output
The quality of the triage narrative (not just the severity label) is the demo's wow-factor. The routine prompt is structured to produce a chain-of-thought that explains *why* a severity was assigned and *what* to do next, not just a JSON label.

## Risks / Trade-offs

- **Concurrent runs**: Push event and a manual re-run could process the same incident simultaneously, creating duplicate GitHub issues. Mitigation: check `gh issue list` before creating; acceptable risk for demo.
- **`gh` CLI auth failure**: Routine will exit with a clear error. State file is not written, so the incident retries on next trigger. No silent failures.
- **Runbook mismatch**: If no runbook matches an incident's symptoms, the routine still produces triage output with a note that no runbook was found and defaults to P2 severity.

## Migration Plan

1. Create `agent-state/` directory with an empty `processed.json` (`{"incidents": {}, "compliance": {}}`)
2. Create `violations/` directory
3. Create GitHub labels: `incident`, `P0`, `P1`, `P2`, `P3`, `compliance`
4. Set `GITHUB_TOKEN` in Claude Code Routines UI
5. Register `incident-triage` routine with push trigger on `issues/*.json`
6. Register `compliance-drift` routine with push trigger on `contracts/*.md` and `compliance-policy.md`
