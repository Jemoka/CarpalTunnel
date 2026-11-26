---
name: prepare-wager
description: Prepare a declared bet when the user asks to implement or ready a wager without running it. Verify the implementation and configs, submit the WIP review stack and record a reproducible handoff.
---

# Prepare a wager

## Reconstruct the declaration

Read the complete bet, owning project journal, relevant sources and [execution contract](../execution-workflow.md). Resolve the implementation repository and its guides from **Workspace setup**. State the treatment, control, replicates, held-fixed resources, decision and guardrail metrics, implementation rows and acceptance checks. Resolve ambiguity that changes the scientific question with the user. Agree on L/XL resources before implementation.

## Implement the declared comparison

Use the configured implementation branch and worktree for this bet. Inspect the closest existing extension, its tests, configuration mechanism and result path before editing. Trace the control and treatment from the normal entry point to the measured output. Explain any required change outside documented extension points before proceeding.

Implement the smallest changes that exercise the declared comparison. Keep each change in its owning component. Reuse the normal input, execution, evaluation and result paths. Expose experiment-changing values through the repository's config mechanism. Keep the control, data ordering, seed plan, budget and success threshold fixed. Prepare complete launch inputs in `configs/<project>/<bet-id>/`, including the evaluation cadence, final evaluation, result destination and exact checkpoint selection where applicable.

For declared figures, specify the exported values, script and durable output path. Use the canonical `scripts/plot_style.py` and copy it byte-for-byte to the project's scripts directory for standalone reporting. Keep display transformations independent of the measured values.

## Verify and submit for review

Audit the actual diff against the engineering and disclosure rules. Resolve accidental changes to the baseline, one-use helpers, disconnected config fields or duplicate execution paths. Run the repository's hooks, focused unit tests, config validation and non-executing CLI checks. Verify each launch command can be reconstructed from the recorded code and configs. Smoke runs and scientific evaluations belong to placement.

Commit wager-owned implementation changes and use the WIP route in the execution contract. Include links to the bet and configs, the control and treatment, verification evidence, and the intended commands. Update existing changes by their review identity. Record the review URLs, patch sets and tip revision. If the team selected a local-only handoff, record that choice explicitly.

## Record the handoff

Write this drawer under the bet's `* outcome` heading using the actual values:

```org
:PROPERTIES:
:IMPLEMENTATION_STATUS: ready
:IMPLEMENTATION_REPO: <canonical repository URL>
:IMPLEMENTATION_BRANCH: <implementation topic>
:IMPLEMENTATION_COMMIT: <full SHA>
:IMPLEMENTATION_CONFIGS: <paths to the runnable configurations>
:IMPLEMENTATION_VERIFIED: <tests and dry checks>
:IMPLEMENTATION_REVIEW: <ordered review URLs or agreed local-only policy>
:END:
```

Mark ready only after verifying the branch, revision, configs, checks and required WIP stack. If a requirement is blocked, record the blocker and use `IMPLEMENTATION_STATUS: blocked`. Set implementation-only rows to `implemented`, leave scientific run rows pending and leave conclusions empty. Keep preparation bookkeeping in the bet. The handoff names the exact implementation and how to launch it.
