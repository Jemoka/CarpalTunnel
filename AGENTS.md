# Working in WRIST

Use this workspace for engineering work and scientific records. When a user hands you a repository to set up for wristing, use [Welcome Bootstrap](.agents/skills/welcome-bootstrap/SKILL.md). Configure only the repositories selected for that workspace.

## Workspace setup

This is the blank template. Bootstrap replaces this paragraph with the adopted repository URLs, roles, branch and review conventions, and execution instructions. The upstream examples are listed in the [README](README.md).

## Git conventions

- Never create or push Git tags. Record full commit SHAs for provenance.
- In this template and a standalone WRIST records repo, work on `main` unless the user specifically authorizes a different records branch. An implementation topic or worktree belongs to the configured code repo. In an in-place installation, follow the publication and branch rules agreed for the target during bootstrap.
- “Commit” and “push” authorize ordinary Git operations on the current state and branch. Create or draft a PR only when explicitly requested by the user or required by an explicitly invoked workflow. Invoke `yeet` only on explicit request.
- Open at most one new SSH connection per five minutes, including pushes and transfers. Record new connection times and reuse live sessions.

## Records and workflows

- Keep ongoing questions, findings, the bets table and a chronological log in `projects/<project>/journal.org`. Start a project when the user has work for it. Use the target’s engineering conventions for everyday tasks.
- Search the project journals, existing bets, papers and factoids before developing an idea. Discuss a proposed experiment with the user. Research workflows are explicitly invoked.
- [Make a bet](.agents/skills/make-bet/SKILL.md) declares the hypothesis, controls, measurements, decision rule, size and patchpoints in `bets/`. Link it from the owning project's bets table.
- [Prepare a wager](.agents/skills/prepare-wager/SKILL.md) implements and verifies a declared bet and submits its WIP review. [Place a wager](.agents/skills/place-wager/SKILL.md) uses that handoff or prepares the missing implementation, then dispatches, babysits, measures and records the outcome. [Close a wager](.agents/skills/close-wager/SKILL.md) resolves an existing wager from its evidence. Discuss infrastructure up front for L/XL work.
- Keep implementation in the registered code repository, reproducible launch inputs in `configs/<project>/<bet-id>/`, and evidence in the owning project. Read the [execution contract](.agents/skills/execution-workflow.md) alongside the implementation repo's instructions. The [checkpoint migration workflow](.agents/skills/checkpoint-migrate/SKILL.md) applies when an authorized task needs a historical run converted.
- Use [Read a paper](.agents/skills/read-arxiv-paper/SKILL.md) when asked to read and record a paper. Keep source bundles, PDFs, summaries, request manifests and ID/build registries under `papers/`. Keep reusable claims in `factoids/`.
- Keep narrative updates scientific. Record operational details in the bet and run logs. Propose follow-up bets for discussion and wait for an explicit request before implementation or dispatch.

## paper records

Paper reading is a scientific reconstruction task, not a journal-club abstract.
For every requested paper:

1. Read the primary source, including methods, appendices needed to implement
   the method, result tables, decisive ablations, negative results, and
   limitations. Do not draft from the abstract alone.
2. Create one Stable Contribution ID and use it consistently for
   `papers/bundle/`, `papers/pdf/`, `papers/summaries/`, `papers/ids.jsonl`, and
   paper references from factoids.
3. Explain both the *claim* and the *algorithm*. Reconstruct central claims,
   assumptions, scope, evidence, and unsupported broader readings. Separately
   give a baseline-first, execution-order method description sufficient for a
   reader to mentally reimplement it.
4. Use common notation with shapes and domains. Identify every learned, fixed,
   sampled, and input-computed object; count new parameters; state training and
   inference differences; and compare time, memory, and systems overhead with
   the same baseline.
5. Interpret evaluations rather than listing them. For each key result, name the
   setup, model, dataset, baseline, metric, absolute values or delta, held-fixed
   resource, supported conclusion, and limitation. Include mechanism ablations
   and regressions.
6. Treat the files in `papers/summaries/` as the deliverable. Chat may provide a
   short index or synthesis after the files are complete, but must not replace
   or preempt them.

For a batch of papers, parallelize disjoint paper sets when requested or when
the batch is large. Each worker owns whole paper records; one coordinator owns
shared registries and the final cross-record audit. A first-pass inventory is
not completion. Do not report success until every requested source maps to
exactly one summary and the paper-reading audit passes.

At the start of every paper-reading request, including a single paper, persist
the deduplicated inventory as
`papers/requests/MMMddyyyy-short_description.jsonl`, with canonical `url` and
resolved `id` fields matching `papers/ids.jsonl`. Normalize arXiv URLs to
unversioned `https://arxiv.org/abs/<id>` form. The manifest is immutable scope:
add resolved IDs as papers are identified, but never remove a requested entry
to make an audit pass. Before drafting, compare the manifest line by line with
the user's request; automation can detect duplicate or missing artifacts, but
cannot detect a paper omitted while the manifest itself was constructed.

Automated validation is necessary but not a scientific review. Before reporting
completion, manually reopen the primary source and audit the summary's method
trace, claim-to-evidence links, and quoted numbers. In delegated batches, the
coordinator must source-check at least one complete record from every worker and
every record whose source, notation, or result interpretation was ambiguous.

## factoid records

Factoids are independent, reusable claims or methods, not spare bullets from a
paper summary. Follow `factoids/AGENTS.md` whenever creating or referencing one.
In particular:

- Factoid IDs and filenames use `MMMddyyyy-factoid_title`, never a paper Stable
  Contribution ID.
- Put each factoid in the most specific existing topic directory. Create a new
  topic only when no existing topic fits.
- A paper summary's `Factoids` section lists factoid IDs only. Do not place
  unrecorded prose claims or proposed IDs there.
- Never leave orphan references: every listed factoid must exist, every relative
  Org link must resolve, and paper citations inside factoids use
  `@LastNameYYYY-One_Line_Underscores`.

## Research writing and conclusions

State the finding in plain language and name the treatment, comparison and measurement.

- Walk through the mechanism with concrete objects and operations. Use a short
  equation or annotated code when that explains the idea better than prose.
- Define a measurement before interpreting it. Explain what changed, what was
  held fixed, and what the denominator counts.
- Put comparable numbers in a small table, and link the plot being discussed.
  Explain the particular pattern the reader should look at.
- Report failures, surprises and uncertainty. Separate what you measured from the mechanism you think could explain it.
- Keep run IDs, hashes, dispatch history, and verification receipts in the
  execution/evidence section. Conclusions should explain the experiment and
  what we learned, with links to that bookkeeping when needed.
- Before finishing, replace vague summary phrases with the actual behavior.
  Do not claim a mechanism is established because accuracy or a plot improved.

## style guide
We are serious engineers writing serious code. This means that we should not be writing spaghetti. Before you write, consider:

1. DO NOT create functions that are called once
2. DO NOT create god functions
3. Functions with similar behaviors should have similar, semantic names `measure_this` `measure_that_or_this`
4. A file/module should contain one conceptual thing; if you need to create large helpers, create a utils folder/file but it must then contain **only flat, non-interdependent utilities**
5. Never have a large wall of something: not a large wall of different functions, not a large wall of methods, not a large wall of classes
6. Code's protos should imply logic; do not have functions lying around where how they are chained together is not immediately obvious
7. Prefer conventions when possible; `new`, etc., are great things. Similarly to before, actions of objects should be semantically clear, there should not be many more public methods beyond the action intended for that object.
8. Unless you are running autonomously (i.e. in goal mode), you should STOP whenever you encounter something that you can't solve / you are confused about instead of assuming things.

## identifiers

### Stable Contribution IDs
A bunch of places require referring to specific scientific contributions. When doing so, refer to the following format.

`LastNameYYYY-One_Line_Underscores`

### Stable T-Shirt Sizes
Used across documentation.

- **XS**: simple to implement, fire and forget, comes back in <30 minutes, no GPU
- **S**: simple to implement, comes back in a few hours, requires GPU infra
- **M**: simple to implement, comes back within a day, requires GPU infra
- **L**: reasonable to implement, is a concrete "bet" which requires upfront resource planning
- **XL**: difficult to implement without changing the implementation repository’s infrastructure or upfront time.
