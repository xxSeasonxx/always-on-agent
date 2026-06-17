#!/usr/bin/env bash
# Run once to create GitHub labels needed by the always-on-ops-agent routines.
# Requires: gh CLI authenticated, run from repo root.

set -e

gh label create "incident"   --color "D93F0B" --description "Production incident" 2>/dev/null || echo "label 'incident' already exists"
gh label create "P0"         --color "B60205" --description "P0 — All customers affected" 2>/dev/null || echo "label 'P0' already exists"
gh label create "P1"         --color "E4E669" --description "P1 — One tenant affected" 2>/dev/null || echo "label 'P1' already exists"
gh label create "P2"         --color "0075CA" --description "P2 — Limited impact" 2>/dev/null || echo "label 'P2' already exists"
gh label create "P3"         --color "CFD3D7" --description "P3 — Single user affected" 2>/dev/null || echo "label 'P3' already exists"
gh label create "compliance" --color "5319E7" --description "Vendor compliance violation" 2>/dev/null || echo "label 'compliance' already exists"

echo "Done. All labels ready."
