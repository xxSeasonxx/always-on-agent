## Why

Production incidents and vendor compliance drift currently require manual monitoring. An always-on agent that automatically triages incidents and scans contracts creates a compelling demo of autonomous ops — and surfaces the right information at the right time without human polling.

## What Changes

- Introduce a `incident-triage` Claude Code routine that watches `issues/*.json`, cross-references runbooks and deploy history, assigns severity (P0–P3), writes a structured triage block back into the issue JSON, and opens a GitHub issue
- Introduce a `compliance-drift` Claude Code routine that scans `contracts/*.md` against `compliance-policy.md`, writes violation findings to `violations/<vendor>.md`, and opens a GitHub issue per contract with violations
- Add `agent-state/processed.json` for deduplication (two namespaces: `incidents` and `compliance`)
- Add `violations/` directory for compliance output

## Capabilities

### New Capabilities

- `incident-triage`: Reads open issues, correlates with recent deploys and runbooks, assigns severity and recommended actions, writes triage output to repo, opens GitHub issue
- `compliance-drift`: Reads vendor contracts, evaluates each clause against compliance policy, writes violations report to repo, opens GitHub issue per contract

### Modified Capabilities

## Impact

- New files: `agent-state/processed.json`, `violations/<vendor>.md` per contract, routine prompt files for each Claude Code routine
- Requires `GITHUB_TOKEN` environment variable set in Claude Code Routines UI
- Triggered by push events to `issues/*.json` (incident triage) and `contracts/*.md` or `compliance-policy.md` (compliance drift)
- No external dependencies beyond `gh` CLI (bundled with GitHub environments)
