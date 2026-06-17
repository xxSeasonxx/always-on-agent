## ADDED Requirements

### Requirement: Detect changed or new contracts
The routine SHALL hash the content of each file in `contracts/*.md` and compare against hashes stored in `agent-state/processed.json` under the `compliance` namespace. A missing or changed hash means the contract must be evaluated.

#### Scenario: New contract file
- **WHEN** a contract file has no entry in the `compliance` namespace of `agent-state/processed.json`
- **THEN** the routine SHALL evaluate it against the compliance policy

#### Scenario: Unchanged contract
- **WHEN** a contract file's hash matches the stored hash
- **THEN** the routine SHALL skip it

#### Scenario: Amended contract
- **WHEN** a contract file's hash differs from the stored hash
- **THEN** the routine SHALL re-evaluate it, replacing the prior violations file

### Requirement: Policy change triggers full re-scan
The routine SHALL detect changes to `compliance-policy.md` by hashing its content. If changed, the routine SHALL invalidate all contract hashes in state and re-evaluate every contract.

#### Scenario: Policy file changed
- **WHEN** `compliance-policy.md` has changed since the last run
- **THEN** all entries in the `compliance` namespace SHALL be cleared
- **THEN** every contract SHALL be evaluated against the new policy

### Requirement: Evaluate each contract against all policy dimensions
The routine SHALL evaluate each contract against all seven dimensions in `compliance-policy.md`: data residency, audit rights, termination, liability cap, subprocessors, breach notification, and governing law.

#### Scenario: Violation found
- **WHEN** a contract clause violates a policy dimension
- **THEN** the dimension SHALL be recorded as a violation with a brief explanation of what the contract says vs. what the policy requires

#### Scenario: Dimension passes
- **WHEN** a contract clause satisfies a policy dimension
- **THEN** the dimension SHALL be recorded as passing

### Requirement: Write violations report
The routine SHALL write a Markdown violations report to `violations/<vendor-slug>.md` containing: review date, contract hash, list of violations with explanations, and list of passing dimensions.

#### Scenario: Violations report created
- **WHEN** evaluation completes for a contract
- **THEN** a file SHALL be written at `violations/<vendor-slug>.md` with all findings
- **THEN** the file SHALL be committed to the repo

#### Scenario: Clean contract (no violations)
- **WHEN** a contract passes all policy dimensions
- **THEN** the violations report SHALL still be written, noting zero violations

### Requirement: Open GitHub issue for contracts with violations
The routine SHALL create a GitHub issue for each contract that has one or more violations, titled `[Compliance] <Vendor Name> — <N> violation(s) detected`, with the violations report as the body and the `compliance` label applied.

#### Scenario: GitHub issue created for violations
- **WHEN** a contract has one or more violations and no open GitHub issue already references it
- **THEN** a GitHub issue SHALL be created via `gh issue create`

#### Scenario: No issue for clean contracts
- **WHEN** a contract has zero violations
- **THEN** no GitHub issue SHALL be created

#### Scenario: Duplicate prevention
- **WHEN** an open GitHub issue already references the same vendor's contract
- **THEN** the routine SHALL skip creation and log a message

### Requirement: Update state after successful processing
The routine SHALL write the contract filename, content hash, violation count, and `processed_at` timestamp to `agent-state/processed.json` under the `compliance` namespace only after all other steps succeed.

#### Scenario: State written on success
- **WHEN** the violations report is written and GitHub issue is created (if applicable)
- **THEN** the contract entry SHALL be updated in `agent-state/processed.json`

#### Scenario: State not written on failure
- **WHEN** any step fails
- **THEN** the contract's hash SHALL NOT be updated in state, ensuring retry on next trigger
