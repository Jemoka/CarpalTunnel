---
name: place-wager
description: Dispatch, babysit, measure, plot, record, and publish a declared bet, implementing it first only when it is not already annotated as implementation-ready. Use only when the user explicitly asks to place, run, shepherd, or execute a wager.
---

# Place a wager

Turn one already-declared bet into a reproducible experiment, keep every run
healthy through completion, judge it against its predeclared measurements, and
close the research record. Placing a wager authorizes implementation when
needed, dispatch, monitoring, scientifically invariant repairs, measurement,
final plots, bookkeeping, and the configured WIP review for this bet. It does not authorize
changing the hypothesis or launching a follow-up bet.

## 1. Reconstruct the wager and inspect its handoff

Read [the current execution and analysis contract](../execution-workflow.md).
Archived configurations and historical ready handoffs do not establish current
API readiness. Generate fresh execution configs as needed in the same
project/bet folder structure and verify their implementation before dispatch.

Read the complete bet. Search `projects/`, `bets/`, `factoids/`, and
`papers/summaries/` for its ID, tags, methods, and prior results. If it belongs
to a project, resolve it as `projects/<project>/journal.org` and read that
journal's bets table and chronological log. Project folders may also contain
user-added screenshots or note images; inspect them when relevant and preserve
them as-is. Inspect the named patchpoints in the configured implementation repository and relevant
configurations in top-level `configs/`.

Write down, in chat, a compact execution contract:

- exact hypothesis and the result that would validate, invalidate, or leave it
  inconclusive;
- treatment, control, seeds/replicates, primary and guardrail metrics, and the
  comparison/statistical rule;
- held-fixed resources such as tokens, steps, wall-clock budget, parameter
  count, or GPU-hours;
- required code patchpoints, configuration files, run grouping and result destination,
  and likely infrastructure;
- experiment row(s), order/dependencies, Stable T-Shirt Size, and estimated
  resource count/duration.

Do not silently repair an underspecified bet. Stop and discuss missing controls,
measurements, thresholds, or ambiguous patchpoints. For L/XL work, agree with
the user on infrastructure and resource planning before implementation or
dispatch. For XS/S/M work, use the first suitable configured infrastructure
unless the bet constrains it.

Inspect the preparation drawer under `* outcome`. Verify the recorded repository, branch, full commit, runnable configs, dry checks and WIP review revision against the declared work. A matching older handoff may identify the repository through **Workspace setup**. Report any mismatch. When the handoff is valid, reuse the exact implementation, unit-test the risky boundary and proceed. If only the review is missing, submit the verified code to the agreed review route. Keep historical run SHAs when review revisions differ.

## 2. Prepare missing implementation

Follow [Prepare a wager](../prepare-wager/SKILL.md) for missing implementation, configuration, verification, WIP submission and the ready annotation. Placement includes that work. Preserve approved code unless a demonstrated failure requires an invariant repair. For a larger change, record the affected requirement and discuss it with the user. Complete independent rows where possible.

Check that long runs have a useful periodic evaluation cadence and that the final suite evaluates the declared budget. Validate the cadence against actual steps and durable metrics. Use the repository's existing analysis path to inspect saved runs. Retain per-seed values, checkpoint identities, aggregation code and any exclusions. Put reproducible figure scripts under `projects/<project>/scripts/` and figures under `projects/<project>/figures/<bet-id>-<figure>.pdf`. Copy and use the canonical plotting helper. Render and inspect each final figure at its intended size.

## 3. Dispatch and record the takeover instructions

Maintain `configs/<project>/<bet-id>/takeover.md` with the wager goal, resource requirements and lessons, and the exact launch commands including working directories and environment overrides. Resolve the runner, resources and storage from the implementation repo's execution guide and active configuration. Use the selected provider's submit, status, log and recovery commands throughout each job. For a local runner, record its equivalent process and artifact locations.

Run the declared tasks in dependency order. At dispatch, record each config, code SHA, execution and attempt IDs, provider job ID, log path and serialized dispatch or equivalent launch receipt. Send the user the config and receipt locations and keep the takeover instructions current. Apply the shared cancellation and retry identity rules across handoffs.

## 4. Babysit to a terminal scientific result

Preserve the dispatch ID across retries where the runner supports it. Keep each attempt's history and resume a verified checkpoint when available. Preserve the selected run's identity for inspection.

Run one monitoring tick immediately after dispatch, then continue monitoring
until all required runs complete or a genuine blocker requires the user. A tick
must be finite: use one-shot status/log commands, never an unbounded `tail -f`
or log follow. Report meaningful transitions rather than repeating unchanged
healthy state.

Do not terminate the pursuit of a wager unless the user explicitly asks. Manage
individual allocations with the standard babysitting recipes for the selected
control plane: diagnose their actual progress, preserve forensic evidence,
reconstruct the exact launch command, and cancel, repair, retry, or replace them
when those recipes call for it. Every intervention must preserve the wager's
scientific question and the invariants below. Do not cancel a healthy,
progressing allocation merely because another use of the hardware looks more
valuable, it may outlive an estimate, a cleaner replacement is queued, or
stopping would simplify analysis.

On a resumed goal, the goal text describes the desired end state and historical
authorization; it is not a queue of commands to replay. Re-evaluate each action
against current scheduler and run-record state. In particular, never use an old
request to remove predecessor jobs as authority to cancel healthy successors.

For every failure, preserve the scientific question:

- Transient node, network, NCCL, rate-limit, or filesystem failure: retry or
  replace through the same control plane.
- Mechanical code/config bug: trace it, make the smallest obvious correction,
  test, commit only that correction, and relaunch/replace.
- Out of memory: inspect actual placement and memory use. Adjust supported microbatching or sharding only when the declared effective workload and comparison remain fixed.
- Checkpoint restore failure: verify the run identity, format, saved step, content and access. Repair the restore path and resume the verified state. Preserve the original checkpoint and dispatch history.
- Missing credentials/image/data, unreconstructable launch command, or the same
  exact error after more than two attempted fixes: flag that job, escalate the
  missing input or decision, and resume its repair once resolved. This does not
  terminate pursuit of the wager.

Do not autonomously change effective global batch, architecture, optimizer,
loss, LR/schedule, dataset/mixture/order/tokenization, seed plan, evaluation, or
success threshold. Those change the wager. Discuss and amend the bet before
continuing if such a change is necessary.

## 5. Measure against the declaration

Do not judge from the last log line. Retrieve finalized metrics and analysis
artifacts from the authoritative result store using the configured
paths and access route described in [the retrieval contract](../execution-workflow.md).
Actually read/export the rows and artifact bytes; a root path or UI link alone
is not measurement evidence. Use scheduler state and logs to verify completion. Verify run identity, commit/config, seed,
completion, sample/token/step count, and held-fixed resources before comparing
metrics. Exclude or rerun incomplete/corrupt runs according to the predeclared
rule; never silently cherry-pick seeds or checkpoints.

Run or verify the complete evaluation suite for each adjudicating arm at its exact declared budget. For checkpointed runs, use the selected final checkpoint. Integrated terminal
evaluation counts only when the whole suite completed and its exact scalar
results were durably saved. Otherwise, run the existing evaluator on the saved outputs. Persist a machine-readable result artifact (for
example `results.json`) containing the checkpoint identity and full-precision
metrics, copy or link it into the wager's durable project artifacts, and record
the evaluation job and exact run or checkpoint identifier. Confirm that the expected metrics and durable result artifacts were retrieved. Do not close a wager from
rounded console output or from metrics buffered in memory before a later
evaluation component failed.

Audit periodic evaluations separately from the mandatory final evaluation.
Confirm that the configured cadence fired as intended, preserve the histories
needed to interpret training, and explain any missing interval. Periodic
metrics may diagnose or guide invariant repairs, but only the predeclared
checkpoint and aggregation rule adjudicate the wager.

Produce a compact result table containing each control/treatment run, job/run
link, seed, terminal status, primary metric, guardrails, and resource use. Then
apply the declared aggregation and threshold. Distinguish:

- **validated**: declared success rule passes and guardrails hold;
- **invalidated**: declared failure/equivalence rule passes;
- **inconclusive**: insufficient power, missing runs, or neither rule passes.

A non-significant difference is not automatically evidence for the null unless
the bet predeclared an equivalence/non-inferiority test.

Prefer one broad, glanceable primary-results table containing every
adjudicating arm, dataset, sample count, metric, uncertainty interval,
threshold, and verdict over several small tables or a prose enumeration of
values. Add a second table only for a genuinely different result family, such
as a mechanism probe. Tables and figures carry the evidence; prose should state
the result and its scope rather than repeat every cell.

Discuss the interpretation with the user before treating an ambiguous result
as closed.

Create the predeclared validation figures using the project plotting convention
from section 2. Check that every wager figure has a matching reproducible analysis job
and checkpoint query, or cross-run export/plot script, is named with the bet ID, and exists under the
project's `figures/` directory before closing the record.

## 6. Close every record and update the WIP review

Update the bet's experiment table and `outcome` with status, exact run links,
measurement table/summary, deviations, code SHA, config paths, figure links,
and a concise interpretation. Apply the factoid quality bar: keep only decision-
relevant information and state every fact and qualification once. Under
`** conclusions`, give each finding one concise third-level Org heading and at
most one short paragraph. Use lists or bold lead-ins only for genuinely
parallel content; do not impose fixed labels. Put run/result links and a bare
relative Org image link for every adjudicating figure directly under the
conclusion they support. Omit prose introductions and repeated summaries. Do
not modify or omit the required measurements, run identities, deviations, code/config
provenance, figures, or adjudication merely to shorten the prose. Do not modify
the owning project journal for implementation, dispatch, local testing, monitoring,
retry, completion, or review milestones. Update its bets table and chronological
log only after measurements
support a scientific finding: a validated, invalidated, or explicitly
inconclusive outcome with a concise interpretation. Link back to the bet, run
evidence, and final figures. Until then, keep all operational state in the bet
and `runlogs/`.

Write the completed `outcome` as an academic results section. Every conclusion
heading must be a result claim, like an academic `\paragraph{<result claim>}`,
not a topic label such as “Performance,” “Analysis,” or “Artifacts.” Lead with
the primary table and verdict, minimize words, and place each supporting figure
inline immediately after the result text or table that refers to it. Keep
artifact indexes and execution provenance outside `** conclusions` so they do
not interrupt the scientific argument.

Create factoids only for reusable, independently supported claims or methods,
and follow `factoids/AGENTS.md`; do not manufacture a factoid from an
inconclusive result. Follow-up bets may be proposed but not implemented or
dispatched without a new explicit instruction.

Update the existing WIP review with run evidence, checks, final figures, status and deviations. Use the configured backing branch and review destination, retaining the same review identities. Record the final review revision separately from historical execution SHAs. Respect the team's readiness and merge rules. Verify that required runs are terminal, values and plots are available, and the bet and project journal agree.

## 7. Remove wager branches after closure and confirmed merge

Once the wager is closed and the entire implementation stack is confirmed merged, clean up its worktrees and topic branches according to **Workspace setup**. Record cleanup as pending when review is still open. Scientific closure can precede merge.

Verify the exact local and remote branch names, expected tips, review status and content, including squash or rebase changes. Check for unsubmitted work, dirty worktrees and live jobs or successors. Preserve historical execution commits in durable Git refs before deleting their last branch reference. Record review URLs, execution SHAs and cleanup targets. Remove clean wager worktrees through Git, and use an explicit expected-tip lease for remote deletion. Verify the named refs are gone. Preserve unrelated branches and the configured base.
