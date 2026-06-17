## ADDED Requirements

### Requirement: Detect unprocessed incidents
The routine SHALL read all files in `issues/*.json` and skip any whose ID appears in the `incidents` namespace of `agent-state/processed.json`.

#### Scenario: New incident not in state
- **WHEN** a new `issues/PROD-XXXX.json` file exists and its ID is absent from `agent-state/processed.json`
- **THEN** the routine SHALL process it

#### Scenario: Already-processed incident
- **WHEN** an issue ID exists in `agent-state/processed.json` under `incidents`
- **THEN** the routine SHALL skip it without modification

### Requirement: Correlate incident with recent deploys
The routine SHALL read `deploys/recent.json` and identify any deploy that occurred within 60 minutes before the incident's `opened_at` timestamp.

#### Scenario: Correlated deploy found
- **WHEN** a deploy to a relevant service occurred within 60 minutes before the incident opened
- **THEN** the triage output SHALL name the deploy (service, version, deployed_at) as the likely cause

#### Scenario: No correlated deploy
- **WHEN** no deploy occurred within 60 minutes before the incident
- **THEN** the triage output SHALL note "no recent deploy correlated"

### Requirement: Match relevant runbook
The routine SHALL select the most relevant runbook from `runbooks/*.md` based on the incident's service name, error message, and symptoms.

#### Scenario: Matching runbook found
- **WHEN** a runbook covers the symptoms described in the incident body
- **THEN** the triage output SHALL reference the runbook by name and include its recommended actions

#### Scenario: No matching runbook
- **WHEN** no runbook matches the incident symptoms
- **THEN** the triage output SHALL note "no matching runbook found" and default severity to P2

### Requirement: Assign severity
The routine SHALL assign a severity level using the runbook's severity guide when available, otherwise using: all customers affected → P0, one tenant affected → P1, single user → P3, ambiguous → P2.

#### Scenario: Severity from runbook guide
- **WHEN** the matched runbook contains a severity guide
- **THEN** the routine SHALL apply that guide to assign P0–P3

#### Scenario: Severity from heuristics
- **WHEN** no runbook is matched
- **THEN** the routine SHALL infer severity from affected user count and scope in the issue body

### Requirement: Write triage block to issue JSON
The routine SHALL add a `triage` object to the issue JSON containing: `severity`, `likely_cause`, `runbook`, `recommended_actions` (array), and `triaged_at` (ISO timestamp).

#### Scenario: Triage block written
- **WHEN** the routine completes triage
- **THEN** the issue JSON SHALL contain a `triage` key with all required fields
- **THEN** the updated file SHALL be committed to the repo

### Requirement: Open GitHub issue
The routine SHALL create a GitHub issue titled `[<severity>] <incident-id> — <incident title>` with the triage block formatted as the body, and apply labels matching the severity and `incident`.

#### Scenario: GitHub issue created
- **WHEN** triage completes and no open GitHub issue with the same incident ID exists
- **THEN** a GitHub issue SHALL be created via `gh issue create`

#### Scenario: Duplicate prevention
- **WHEN** an open GitHub issue already references the same incident ID
- **THEN** the routine SHALL skip creation and log a message

### Requirement: Update state after successful processing
The routine SHALL write the incident ID, severity, and `processed_at` timestamp to `agent-state/processed.json` under the `incidents` namespace only after all other steps succeed.

#### Scenario: State written on success
- **WHEN** triage output is written and GitHub issue is created
- **THEN** the incident ID SHALL be added to `agent-state/processed.json`

#### Scenario: State not written on failure
- **WHEN** any step fails (file write, gh CLI, etc.)
- **THEN** the incident ID SHALL NOT be added to state, ensuring retry on next trigger
