---
name: checkpoint-migrate
description: Migrate an identified historical run from filesystem checkpoints and logs into the configured checkpoint store without modifying or deleting the originals. Use when requested or when an authorized historical-run analysis or continuation requires migration. Creates one node per checkpoint and reconstructs available metric history using current APIs; does not authorize new scientific runs.
---

# Checkpoint migrate

Make a historical run usable through the target repository’s checkpoint queries, store
inspection, and analysis APIs. Migration is permitted as part of an authorized
task that needs that run; do not ask again merely because its checkpoints use
the old layout. Do not bulk-migrate unrelated runs. This skill authorizes
conversion, storage writes, and restoration checks, not training, new scientific
evaluations, or deletion of source checkpoints. Use the existing task's compute
authorization; discuss additional infrastructure only when necessary.

Read [the current workflow contract](../execution-workflow.md). Follow the configured workspace branch and review policies. This workflow does not require or authorize a PR.
Keep reusable implementation in the configured implementation repository and project-specific migration/export
scripts and manifests in `projects/<project>/scripts/` and `data/` respectively.

## Inventory and reconstruct

Identify the requested source run, its original code commit, config, dataset,
tokenizer, optimizer, schedule, checkpoint format, and available logs/artifacts.
Locate source and destination using the actual dispatch configuration and
remote access route. Inspect the historical loader at the source commit and
the current checkpoint writer, reader, restore path and query API; do not assume that a directory rename converts checkpoint formats.

Persist an inventory before writing destination data. Include every source
checkpoint, source content checksums, observed saved step/token counters,
logs/config provenance, and intended destination node. Resolve symlinks and
identify aliases to the same checkpoint; record aliases without inventing extra
saved states. Incomplete checkpoints stay in the inventory with an explicit
failure; never drop one to make the migration appear complete.

Create one stable destination node for each distinct source checkpoint, with
the original project/group/run identity and one stable run identity for the entire
historical treatment lineage, recorded in the manifest. Reuse the historical
run identity when available; otherwise allocate it once for that lineage, never per
checkpoint or analysis. Recover optimizer steps from saved state and the historical
trainer's counting rules. Do not mistake token-count directory names, logging
event counters, or microbatches for optimizer steps. Preserve original counters
as provenance and document any exact conversion. If evidence cannot determine
the mapping or distinguish conflicting states at one step, stop that conversion
and ask for the missing information; do not silently renumber or merge them.

Represent verified chronology and actual forks in parent links. Add metric-only
nodes at observed non-checkpoint steps so the original history remains visible;
each checkpoint node joins that history at its verified step. Missing log
intervals remain gaps. Reuse the manifest's identities on retry; do not allocate
a new nonce and duplicate the run each time.

## Convert without modifying the source

Treat source checkpoints, configs, and logs as read-only. Never delete, rename,
move aside, overwrite, or use writable hardlinks to them. Copy/re-serialize
state into separate destination storage; the migrated run must not depend on
the originals being writable. Check available capacity before copying.

Use the current repository’s checkpoint writer and result-store APIs and the layout its standard restore path reads. A restorable
node requires more than a row marked as a checkpoint: populate its checkpoint
state, node specification, composed configuration, job identity/class metadata,
and recoverable RNG state in the format those readers expect. Preserve actual
saved parameters, optimizer state, and completed optimizer step. Use an explicit
structural conversion when schemas differ and record every mapping. Never
substitute initialized parameters or optimizer leaves and call it exact migration.

Reconstruct current component config from the historical scientific settings,
including explicit trainer dataset/evaluation/analysis declarations. Put any
new runnable execution YAML under `configs/<project>/<bet-id-or-run>/`, matching the established hierarchy. Preserve historical configs. Verify the actual
registered job class and its imports are available to checkpoint restoration.

Record unavailable RNG, loader cursor, or other state explicitly. A checkpoint
can support parameter analysis without supporting exact training continuation
or deterministic replay of its historical batch. Label those capabilities
separately; do not let a current loader's deterministic behavior imply that a
missing historical cursor was recovered. Prevent an unsupported continuation
from being described as resume-ready.

Reconstruct metric history from original durable logs and saved tracking
exports using the current scalar logging and store APIs. Preserve precision, observed step, phase, source key, and
provenance. Translate keys only when semantics match current metrics; retain
ambiguous historical keys explicitly. Do not interpolate, recompute missing
evaluations, fabricate timestamps, or copy rounded console values over available
full-precision values. Resolve duplicate events using documented source ordering;
retain conflicting evidence rather than silently choosing a favorable value.
Import available non-scalar artifacts through the supported artifact API. Mark their original provenance. Future analyses should select the verified checkpoint and retain its run and tracking identities. Preserve historical dispatch keys separately.

Build and verify each destination checkpoint before publishing its discoverable
checkpoint marker. Wait for asynchronous checkpoint saves and store writers to
finish; a published metadata row alone does not prove the payload is complete.
Inspect the writer’s publication semantics. Do not mark the run
finished unless original completion evidence supports that claim. On failure,
leave a precise incomplete manifest and preserve source and destination evidence.
On retry, verify existing destination content and complete missing work without
overwriting a different node or erasing history.

## Verify and hand off

Reopen the destination through the supported reader and checkpoint queries. Verify
inventory coverage: every requested complete checkpoint maps to exactly one
restorable node, aliases are recorded, and no requested checkpoint disappeared.
Compare each converted state's keys, shapes, dtypes, and values with its source,
including optimizer state and step where available. Exercise normal current
checkpoint restoration for each converted checkpoint without training; compare
restored values so permissive partial restore cannot hide missing leaves.

Retrieve the reconstructed log rows and artifact bytes using the same APIs used
by wager measurement. Compare counts, steps, keys, precision, and representative
plus terminal values against the source; check all translated fields and
conflicts. Confirm node ordering and parent links. Verify source checksums are
unchanged and a repeat invocation would reuse the same nodes without duplicate
history. If infrastructure prevents a required restore check, report that
verification as incomplete rather than claiming migration success.

Record the source-to-node mapping, converter/source/target commits, destination
paths, exact queries, verification evidence, and replay/resume limitations in
the durable project manifest. Link it from the owning bet or project record
without rewriting historical scientific results. Report migrated checkpoint and
metric counts, unresolved failures, and whether analysis, batch replay, and
training continuation were each verified. Explicitly confirm that all original
checkpoints were preserved.
