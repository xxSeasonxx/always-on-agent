## 1. Repo Setup

- [x] 1.1 Create `agent-state/processed.json` with initial content `{"incidents": {}, "compliance": {}}`
- [x] 1.2 Create `violations/` directory (add `.gitkeep`)
- [x] 1.3 Create GitHub labels: `incident`, `P0`, `P1`, `P2`, `P3`, `compliance`

## 2. Incident Triage Routine

- [x] 2.1 Write the `incident-triage` routine prompt: reads all `issues/*.json`, loads `agent-state/processed.json`, skips already-processed IDs
- [x] 2.2 Implement deploy correlation: parse `deploys/recent.json`, find deploys within 60 min of `opened_at`
- [x] 2.3 Implement runbook matching: read all `runbooks/*.md`, select best match based on symptoms/service/error
- [x] 2.4 Implement severity assignment: apply runbook severity guide or heuristic (all customers → P0, one tenant → P1, single user → P3, ambiguous → P2)
- [x] 2.5 Write triage block back to issue JSON (`severity`, `likely_cause`, `runbook`, `recommended_actions`, `triaged_at`) and commit
- [x] 2.6 Create GitHub issue via `gh issue create` with severity label and `incident` label; check for existing open issue first
- [x] 2.7 Update `agent-state/processed.json` incidents namespace with ID, severity, and `processed_at`
- [x] 2.8 Print structured run summary to stdout

## 3. Compliance Drift Routine

- [x] 3.1 Write the `compliance-drift` routine prompt: reads all `contracts/*.md`, loads `agent-state/processed.json`, computes content hashes
- [x] 3.2 Implement policy change detection: hash `compliance-policy.md`; if changed, clear all compliance state hashes to force full re-scan
- [x] 3.3 Implement per-contract evaluation: check each of the 7 policy dimensions (data residency, audit rights, termination, liability cap, subprocessors, breach notification, governing law)
- [x] 3.4 Write violations report to `violations/<vendor-slug>.md` (violations + passing dimensions) and commit
- [x] 3.5 Create GitHub issue via `gh issue create` for contracts with violations; skip clean contracts; check for existing open issue first
- [x] 3.6 Update `agent-state/processed.json` compliance namespace with filename, hash, violation count, and `processed_at`
- [x] 3.7 Print structured run summary to stdout

## 4. Register Routines

- [ ] 4.1 Register `incident-triage` routine in Claude Code Routines UI with push trigger on `issues/*.json`
- [ ] 4.2 Register `compliance-drift` routine in Claude Code Routines UI with push trigger on `contracts/*.md` and `compliance-policy.md`
- [ ] 4.3 Set `GITHUB_TOKEN` environment variable in Routines UI

<!-- See routines/README.md for step-by-step instructions -->

## 5. Demo Verification

- [ ] 5.1 Drop a new issue JSON (copy an existing one with a new ID) and verify triage runs, GitHub issue appears, issue JSON updated
- [ ] 5.2 Amend a contract file and verify compliance drift runs, violations file written, GitHub issue appears
- [ ] 5.3 Confirm re-running either routine produces no duplicates
