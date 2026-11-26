---
name: make-bet
description: Pre-declare a scientific hypothesis as a bet. Use only when the user explicitly asks to formalize, make, or declare a bet.
---

# Make a bet

Convert a research intuition into a falsifiable, sized experiment declaration.
The bet file is a durable pre-registration: it must say what will be built, what
will be measured, and what outcome would change our belief before any result is
known. Declaring a bet does not authorize implementation or dispatch.

## 1. Recover context and deduplicate

Search `projects/`, `bets/`, `factoids/`, and `papers/summaries/` before treating
the idea as new. Each project lives in `projects/<project>/`; its maintained
record is `projects/<project>/journal.org`. Read that journal completely,
including its bets table and chronological log. A project folder may also
contain user-added screenshots or note images; treat them as project context
when relevant and preserve them as-is. Identify whether the request is:

- a new falsifiable claim;
- a duplicate or refinement of an existing bet;
- several separable hypotheses that should become separate bets; or
- an implementation task with no uncertain scientific claim, which should not
  be dressed up as a bet.

Discuss overlaps with the user. Do not create a second bet for the same claim
merely because the proposed mechanism or wording differs.

## 2. Reduce the intuition to the minimum hypothesis

State the smallest causal, comparative, scaling, or engineering claim that the
proposed experiment can actually distinguish. A useful hypothesis names:

- intervention/treatment and control;
- population/model/data regime and evaluation scope;
- primary response variable and direction or equivalence region;
- resource held fixed (tokens, parameters, active FLOPs, wall time, memory,
  inference budget, or another explicit quantity);
- aggregation over seeds/replicates and a decision threshold;
- important guardrails or regressions that would defeat an apparent win.

Prefer a narrow claim that one experiment can answer over a universal claim.
Separate mechanism from outcome: “X lowers validation loss under equal training
tokens” and “X works because it improves routing diversity” are different bets
unless the experiment directly intervenes on the proposed mechanism.

Bad:

```text
Longer context should make the model better.
```

Predeclared:

```text
At equal 10B training tokens and 120M non-embedding parameters, increasing
context from 2,048 to 8,192 reduces mean validation NLL by at least 0.03 across
three fixed seeds, without reducing tokens/s by more than 5% or any named
downstream score by more than one point.
```

If the control, measurement, held-fixed resource, scale, or decision rule is
materially ambiguous, stop and sharpen it with the user rather than filling in
a consequential assumption.

## 3. Use paper evidence at reconstruction quality

Search `papers/ids.jsonl`, `papers/summaries/`, retained bundles, and factoids
for related work. A paper citation in a bet uses its Stable Contribution ID,
`@LastNameYYYY-One_Line_Underscores`, and the corresponding summary must exist.

Read the local summary as a reconstruction, not an abstract: check the stated
claim, algorithm, assumptions, controlled resource, exact evaluation setup,
decisive ablations, negative results, and limitations. Translate that evidence
into scoped motivation. Do not turn “improved two benchmarks at equal active
FLOPs” into “is generally better,” or treat an author-proposed mechanism as
established when its evidence is correlational.

The bet should distinguish three things:

1. **Known locally:** what a summarized source or factoid actually establishes.
2. **Unresolved:** the gap, changed regime, or unsupported interpretation this
   wager tests.
3. **Expected:** the new prediction being predeclared.

If an important paper is not summarized, flag it and explain why it matters.
Do not cite it from an abstract or invoke `read-arxiv-paper` unless the user
explicitly asks to read or summarize it. Declaring a bet is not a paper-reading
request.

## 4. Design the experiment ledger

Read `bets/template.org` before drafting and preserve its headings and table
columns exactly. The `experiments` table is executable scope, not an informal
todo list. Use one row per independently implementable or runnable task, such
as adding an evaluation, adding the treatment, running a smoke check, or running
the controlled comparison.

Treat the checked-in template as authoritative. If this skill's examples or
wording ever disagree with it, follow the template and update this skill.

Keep this table extremely terse. No row should wrap in a normal editor. Use
short task names and acceptance checks; move shared details to `methods` or
`expectation`. If a table feels dense, it is too wordy.

Populate every row as follows:

- `task`: concrete action and treatment/control/seed scope;
- `t-shirt size`: one exact Stable T-Shirt Size for that row;
- `evaluation`: named dataset/evaluation registry key, metric, checkpoint/step,
  aggregation, and threshold relevant to that row. For plumbing, state the
  executable acceptance check (for example registry resolution, output shape,
  finite loss, metric emission, or checkpoint restore);
- `status`: `unimplemented` when declared; later wager execution changes it to
  `implemented`, `running`, or `ran`;
- `outcome`: blank at declaration; later summarize that row's measured result.

Use the repository's sizes literally:

- **XS**: simple, no GPU, fire-and-forget, completes in under 30 minutes.
- **S**: simple GPU task completing in a few hours.
- **M**: simple GPU task completing within a day.
- **L**: concrete bet requiring upfront resource planning.
- **XL**: deep implementation infrastructure changes or substantial upfront time.

Size each row, not just the overall idea. Record dependencies in the task prose
when rows must run in order. The overall scale is the largest row plus material
coordination overhead; do not downgrade a six-run study because each individual
launch is mechanically simple.

## 5. Trace implementation and measurement paths

Read the [execution contract](../execution-workflow.md) and the target repository's extension guide. Inspect its closest existing control, treatment, configuration and evaluation paths. For each proposed change, record the repository, file, existing class or command, smallest new behavior and executable acceptance check. Identify the authoritative metric or artifact, its units, sample mask and aggregation. Describe how each replicate will be identified and how an evaluator selects its checkpoint or output. Put launch inputs in `configs/<project>/<bet-id>/`.

When adjudication requires a figure, predeclare its plotting script and durable
artifact path. Require `scripts/plot_style.py` to remain immutable and be copied
byte-for-byte to a project-local sibling. Require its applicable chart helpers,
font constants, palette, opaque white figure and axes, despined axes, dashed
grids, tight layout, and white-background export.
Importing the module alone does not count. The implementation may adapt panel
arrangement, aspect ratio, shared axes, limits, and scale to the data, but must
not add a wager-specific style helper, modify the canonical template, or alter
stylistic elements such as fonts, colors, markers, line widths, legends, grids,
spines, line weight, or background color.

Be concise but concrete: name the file/class, changed method, metric formula and
mask/aggregation, emitted key, config surface, and smallest acceptance test.
Patchpoints should let an implementer start without re-deriving the design.

## 6. Write the bet in the template's language

Copy `bets/template.org` to:

```text
bets/MMMddyyyy-bet_title.org
```

Use the current date, a lowercase snake_case title, and a concise `#+title`.
Remove template comments/placeholders. Preserve all top-level sections:

- `motivation`: prior evidence, gap, and why resolving it changes a decision;
  link existing factoids with relative Org links and cite summarized papers by
  Stable Contribution ID.
- `methods`: one or two paragraphs describing treatment, control, held-fixed
  quantities, sample/seed plan, and analysis. Keep it baseline-first and in
  execution order; do not turn it into an implementation wall.
- `experiments`: fully populated, row-sized executable ledger.
- `expectation`: the single predeclared overall hypothesis and exact decision
  rule. State validation, invalidation, and when appropriate inconclusive or
  equivalence conditions.
- `patchpoints`: the inspected implementation and measurement plan above.
- `outcome`: initialize status to `unimplemented` and preserve an empty
  `** conclusions` subtree. Later, add one concise third-level Org heading per
  result and state the finding in at most one short paragraph. Use bullets or
  bold lead-ins only when the content has genuinely parallel parts; do not
  force labels onto ordinary prose. Conclusions may point to different runs;
  place each optional result artifact or tracking link and bare relative Org figure link under
  the conclusion it supports rather than imposing bet-level links.
- `notes`: assumptions, risks, unresolved but non-blocking questions, and
  deviations to revisit when placing the wager.

Design the eventual `outcome` as an academic results section. Prefer one broad,
glanceable primary-results table that places all adjudicating arms, datasets,
metrics, sample counts, uncertainty, and decision thresholds side by side over
many small tables or prose recitations. Plan only figures that materially
support a conclusion. Each populated conclusion heading must itself state the
result, like an academic `\paragraph{<result claim>}`, rather than name a topic
such as “Performance” or “Analysis.” Put each figure directly under the result
that interprets it, refer to it in the adjacent prose, and keep prose to the
minimum needed to explain what the table or figure establishes and what it
does not.

Use forward-looking, testable language: “we expect,” “the wager validates if,”
and “held fixed.” Do not write retrospective conclusions, sales language,
unbounded claims, or vague verbs such as “works,” “better,” and “efficient”
without a named metric and comparison.

Write with the factoid quality bar: precise, scoped, scientifically accurate,
and terse. Keep each section to the minimum needed, omit context that does not
change the decision, and state every fact and qualification once. Use lists and
bold semantic lead-ins when they improve scanning, not as a mandatory schema.
Prefer an equation, exact comparison, or operational recipe over explanatory
filler. Simple ideas should produce simple bets, not exhaustive specifications.
This is a presentation rule, not permission to omit any required hypothesis,
control, held-fixed quantity, measurement, decision rule, patchpoint, evidence,
or execution record specified above.

Use Org's LaTeX delimiters for every mathematical object: `$...$` for inline
math and `$$...$$` for display math. Variables, formulas, inequalities, sets,
subscripts, superscripts, and mathematical numeric comparisons must never use
Org verbatim delimiters. Reserve `=...=` for literal code symbols, paths,
registry keys, configuration strings, run/checkpoint IDs, and commit hashes.

## 7. Link and audit the declaration

If the bet belongs to a project, add a relative link and one-line summary to the
project's `journal.org` bets table with status `unimplemented`. Resolve the link
relative to `projects/<project>/journal.org`. Do not append a chronological log
entry for declaring, editing, implementing, or otherwise administering a bet;
those are operational events, not scientific findings. Keep declaration detail
in the bet itself.

Before reporting completion, verify:

- filename/date, title, tags, every template heading, and `** conclusions`;
- every mathematical expression uses LaTeX delimiters rather than Org verbatim
  delimiters, while literal code and identifiers remain verbatim;
- experiment columns exactly `task`, `t-shirt size`, `evaluation`, `status`,
  and `outcome`;
- each populated conclusion has one concise third-level Org heading,
  brief prose or a genuinely useful list, its own supporting result artifact or tracking link,
  and each adjudicating figure embedded with a bare relative Org image link;
- every experiment row has a valid T-shirt size and concrete measurement or
  executable acceptance check;
- expectation can be judged from the declared measurements without inventing a
  rule after results arrive;
- treatment, control, held-fixed resource, seeds, guardrails, and inconclusive
  handling agree across methods, experiments, and expectation;
- every paper ID resolves in `papers/ids.jsonl`, every cited paper has a local
  summary, and every factoid link resolves;
- named implementation paths, classes and registry keys exist or are clearly marked as new;
- the project bets-table link resolves; no declaration log entry was added; and
- `git diff --check` passes.

## 8. Commit and publish the declaration

After the audit, commit only the bet-owned files with the subject prefix `create(bet):` and publish by the records route in **Workspace setup**. Verify the published revision and distinguish declaration from implementation and execution in the handoff.
