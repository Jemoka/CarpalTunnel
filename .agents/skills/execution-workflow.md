# Wager execution contract

Read **Workspace setup** in the records repo's `AGENTS.md` for the implementation repository, its contribution and execution guides, and the agreed branch and review routes. Use the implementation repo's current APIs and documented commands. Resolve checkout paths relative to the appropriate repository. The original [WRIST contract for Theseus](https://github.com/Jemoka/wrist/blob/main/.agents/skills/theseus-workflow.md) gives the engine-specific procedures for workspaces using that backend.

## Branches, configuration and review

Use the configured implementation topic and isolated worktree per bet. Resolve the current base from its configured upstream. Reuse an existing topic after checking its ownership, worktree status and tip. Preserve the primary checkout's branch and local changes. Record the implementation repository, branch and full commit SHA. In a single-repo workspace, include the needed configs on the implementation topic according to its review policy. For a companion workspace, record the implementation SHA alongside the configs in the records repo.

Use one complete launch configuration per active arm under `configs/<project>/<bet-id>/`. If there is no owning project, use the configured implementation repo name. Keep the treatment, seed, resource requirements, code revision, run identity and measurement destination reproducible. Group runs under the exact bet ID and owning project where supported. Document working directories and commands. Keep preferred placement distinct from required hardware.

Install and run the implementation repo's prescribed hooks, tests and disclosure checks. For repos that export public code, inspect the actual exported diff for private experiments, imports and data. Verify the exported code still works before submitting it.

At preparation, publish the verified topic to its configured backing remote if applicable. Submit the full stack through the configured WIP review route. For Gerrit, verify one Change-Id per commit, inspect outgoing dependencies, and push the stack tip to `refs/for/<base>%wip` on the review remote. Record the ordered URLs, Change-Ids, patch sets and tip SHA. Use those same changes for later revisions. Request the configured reviewer and leave WIP in place until the user asks for readiness. Record the issue/topic when provided. Preserve historical execution SHAs separately from rewritten review commits. Apply workspace PR and tag policies.

## Execution, recovery and evidence

Use the configured runner and its documented status, log, checkpoint and artifact interfaces. Inspect resource placement and allocate substantial processing on appropriate compute. Use a control or login node for bounded checks, dispatch and status. Record the exact commands, resource budget, job IDs, log paths and output locations. Enable configured remote experiment logging unless the user asks for local-only logging.

Use one logical run per treatment, task and seed. Record each attempt and stable dispatch/idempotency key where supported. After a checkpoint exists, resume the verified state and tracking identity. Preserve earlier failed attempts. For analysis, select the exact existing checkpoint, inherit its saved configuration, record analysis overrides and verify the resolved run identity before and after execution. Attach per-example and per-checkpoint results to that run. Reserve new scientific lineages for declared changes of stage.

Use the backend's supported reader to export full-precision metrics and artifact bytes from the configured authoritative store. Keep queries, identities, input counts and export scripts alongside the results. Preserve gaps, failures and display-only exclusions. For comparisons that reuse earlier runs, verify their budgets and configuration and link the original run. Associate it with the new bet in the tracker where supported.

Bind cancellation or replacement to the job IDs identified when the user gave the instruction. Record those IDs and the action taken. On handoff or retry, reconcile scheduler state with the saved record before acting on a job.
