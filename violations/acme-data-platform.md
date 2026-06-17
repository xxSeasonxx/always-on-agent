# Compliance Review — Acme Data Platform Ltd.
**Reviewed:** 2026-06-17T00:15:00Z
**Contract file:** contracts/acme-data-platform.md
**Contract hash:** 505a44538f7b1e70ab10e2ad752d4636

## Violations (4)

- **Data residency**: Contract permits processing "in any region where Vendor maintains infrastructure, including the United States, Ireland, and Singapore" and only commits to "reasonable efforts" to keep EU data in the EU without guaranteeing residency — Policy requires a guarantee of EU-only processing for EU customer data; "reasonable efforts" without a guarantee is a violation.

- **Subprocessors**: Contract states "Vendor will update the list within 30 days of any change" — this is a retroactive list update, not advance notice. Policy requires written notice at least 30 days *before* adding a new subprocessor; no such advance notice obligation exists in this contract.

- **Data breach notification**: Contract requires notification "within 96 hours of confirming a security incident" — Policy requires notification within 72 hours of *detecting* a breach; 96 hours exceeds the maximum and the trigger is "confirming" rather than "detecting", widening the window further.

- **Governing law**: Contract is governed by "the laws of the State of California, United States" — California is not on the approved list (England & Wales, Ireland, US Delaware); CCPA provides some data protection but lacks the mature, comprehensive enforcement regime of GDPR jurisdictions; flagged as violation per policy guidance.

## Passing (3)

- **Audit rights**: Customer may audit on 60 days' written notice, once per calendar year — within the permitted 30–90 day notice range. ✓
- **Termination**: Termination for convenience permitted on 90 days' written notice — meets the ≤90 day requirement. ✓
- **Liability cap**: Cap set at 12 months of fees paid; data breach liability arising from gross negligence is explicitly excluded from the cap (i.e., uncapped), which meets and exceeds the policy floor. ✓
