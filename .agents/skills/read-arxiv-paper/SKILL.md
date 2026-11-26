---
name: read-arxiv-paper
description: Read and record one or more identified research papers from primary source, including arXiv URLs, OpenReview/proceedings papers, or venue paper lists. Use when the user explicitly asks to read, explain, or summarize papers. Produces source bundles, Stable Contribution IDs, PDFs when compilable, rigorous Org summaries, factoids where reusable, and audited mappings under papers/.
---

The repository record is the deliverable. A chat response is only a synthesis or
index after the files are complete.

### Part 0: Inventory and batch ownership

On first use, create missing `papers/requests/`, `papers/bundle/`, `papers/pdf/` and `papers/summaries/` directories.

Normalize the user's request into a deduplicated paper inventory before reading.
Resolve shorthand venue entries to exact titles and primary-source URLs. Search
`papers/ids.jsonl`, `papers/summaries/`, and `papers/bundle/` before downloading.

For a large batch, use parallel workers when authorized. Assign disjoint whole
papers, not method/result fragments. One coordinator must own:

- the deduplicated inventory;
- Stable ID collision resolution;
- all edits to `papers/ids.jsonl`;
- final factoid-name and link validation;
- the completion audit.

Workers may create bundle, PDF, and summary files for their assigned papers but
must return canonical URL, Stable ID, compilation outcome, and factoid proposals.
Do not let multiple workers write the shared ID registry concurrently.

For every request, including a single paper, create
`papers/requests/MMMddyyyy-short_description.jsonl` before drafting summaries.
Each row has canonical `url` and resolved `id` fields. Normalize arXiv URLs by
removing `www`, `/pdf`, version suffixes such as `v2`, and query fragments, so
the result is `https://arxiv.org/abs/<numeric-id>`. Never delete a manifest row
because a paper is hard to identify or access.

Compare the completed manifest line by line with the user's original request
before reading. The repository audit treats the manifest as scope and therefore
cannot discover an item accidentally omitted during manifest construction.

For an arXiv paper you will usually be given a URL such as:

https://www.arxiv.org/abs/2601.07372

### Part 1: Normalize the URL

The goal is to fetch the TeX Source of the paper (not the PDF!), the URL always looks like this:

https://www.arxiv.org/src/2601.07372

Notice the /src/ in the url. Once you have the URL:

### Part 2: Download the paper source

Fetch the source archive into a temporary directory and extract it there. Do not
retain the downloaded archive. Keep the extracted source in the temporary
directory until choosing its Stable Contribution ID.

If `papers/ids.jsonl` already maps the paper to an existing bundle, do not
download it again.

For non-arXiv papers, prefer an official source archive from OpenReview or the
proceedings. If only an official PDF is available, retain the PDF and summarize
from it; record the source-access limitation. Never save an anti-bot HTML page
as a source archive or PDF. For arXiv, always prefer TeX source over PDF text.

### Part 3: Locate the entrypoint

Every latex source usually has an entrypoint, such as `main.tex` or something like that.

### Part 4: Read the paper

Once you've found the entrypoint, Read the contents and then recurse through all other relevant source files to read the paper. Find related work as needed and read those too.

Reading the abstract, introduction, and conclusion is not sufficient. Before
writing, locate and read all of the following when present:

1. the complete method and algorithm definitions;
2. every equation needed to execute the method;
3. training-objective and inference-procedure differences;
4. architecture and hyperparameter appendices needed for parameter counts;
5. main result tables, compute/latency tables, and mechanism ablations;
6. limitations, negative results, and sensitivity analyses.

Build a private method trace before summarizing: starting from one input, list
each computed quantity and state mutation in execution order until the output
and loss are produced. If this trace cannot be written precisely, continue
reading instead of drafting the summary.

Also build a private claim-evidence table. For every central claim, record:

- the claim in precise language;
- whether it is empirical, theoretical, mechanistic, or interpretive;
- its assumptions and evaluation scope;
- the exact theorem, figure, table, or ablation offered as evidence;
- plausible broader readings that the evidence does not justify.

The final summary must explain both the claim and the algorithm, and connect
them. A faithful algorithm description without the paper's scientific claims is
incomplete; a list of claims without executable method detail is also incomplete.

### Part 5: Come up with a unique identity

Name the paper semantically, based on memorable things; if the paper introduces a particular method, then stick it there too even if its not in the paper title. Use the following template:

`LastNameYYYY-One_Line_Underscores`

Move the paper bundle and PDF into the relevant locations based on this title:

- `papers/bundle/Vaswani2017-Transformers`
- `papers/pdf/Vaswani2017-Transformers.pdf`

Move the extracted source to the bundle path. Use `tectonic` to compile it once
so that the PDF lands in `papers/pdf/`. If the paper is not compilable, retain
the source bundle and continue without a PDF. Record the URL-to-ID mapping in
`papers/ids.jsonl` to prevent duplicate bundles and summaries.

The output PDF must be named `papers/pdf/<Stable-ID>.pdf`, even when the TeX
entrypoint produces `main.pdf` or another generic name. A failed compilation is
acceptable only after one real attempt; source download failure is not a reason
to omit the summary.

Record exactly one durable outcome in `papers/compilation.jsonl` with fields
`id`, `status`, `attempted_at`, and `reason`. Allowed statuses are `success`,
`failed`, and `source_unavailable`. Use `success` only when
`papers/pdf/<Stable-ID>.pdf` exists. Use `failed` only after a real Tectonic
attempt and retain the source bundle. Use `source_unavailable` only when the
official source/PDF cannot be retrieved and record the endpoint failure. This
registry, not terminal scrollback, proves that compilation was attempted.
Use an ISO date (`YYYY-MM-DD`) for `attempted_at` and write a specific, nonempty
`reason` for every status, including the successful entrypoint used. After a
successful build, verify that the renamed artifact is actually a PDF. The
registry is an audit record, so never infer or backfill an attempt that did not
happen.

### Part 6: Extract Factoids
Visit `factoids/` to see whether the paper contains contributions that should be
recorded as small, reusable factoids.

Read `factoids/AGENTS.md` completely before creating or naming a factoid.
Factoids use `MMMddyyyy-factoid_title`, not the paper's Stable Contribution ID.
Place them in the most specific existing topic directory and follow
`factoids/template.org`. Create the file before adding its ID to the summary.
If no reusable factoid is warranted, write `- None recorded separately.` Never
leave prose proposals or nonexistent IDs in a summary's Factoids section.

### Part 7: Summarize the paper
Write the explanation to
`papers/summaries/LastNameYYYY-One_Line_Underscores.org`. Use **Emacs Org
format**. If an explanation already exists, find it by Stable Contribution ID or
source URL and update it rather than creating a duplicate.

#### Notation

1. **Declare a shared notation block first.** Before writing any math, state all shared symbols, their shapes, and their value domains. Example:
   - $x^{(l)}(t) \in \mathbb{R}^d$: hidden state at layer $l$, token $t$
   - $L$: total layers
   - $d$: hidden dimension
   - $T$: sequence length

2. **Introduce new symbols at first use.** When a new variable appears in an equation, define it immediately after the equation — including its shape and what it represents. Never use a symbol before defining it.

3. **Use standard notation.** Do not adopt the paper's bespoke notation unless the user requests it. Prefer widely understood conventions:
   - $x$ for inputs/hidden states
   - $W$ or subscript $\theta$ for learnable parameters
   - Superscript for layer/time index: $x^{(l)}$
   - Parenthetical argument for token position: $x^{(l)}(t)$
   - Subscript $\theta$ for anything optimizable: $w_\theta^{(l)}$

4. **State shapes explicitly.** Every matrix, vector, and scalar should have its shape stated at introduction. If something is a scalar, say so.

5. **Clarify per-token vs shared.** If a quantity varies per token, say so. If it is shared across tokens, say so. This is a common source of confusion.

#### LaTeX Hygiene

1. **No spacing commands.** Never use `\!`, `\;`, `\,`, `\quad` or similar. They render as literal punctuation in the chat UI.
2. **No `\cases` or `\begin{cases}`**. These do not render. Use prose or separate equations instead.
3. **No `\text{}` wrapping function names** unless it renders cleanly. Prefer writing function names outside the math block if unsure.
4. **Test mentally**: if a LaTeX command is not a standard symbol, operator, frac, sum, prod, exp, sup, sub, or Greek letter, it probably won't render. Don't use it.

#### Explanation Style

1. **Ground everything in the standard/baseline first.** Before explaining the new method, write out the standard approach it replaces, using the same notation.

2. **Show the full equation, then unpack.** Write the equation first, then explain each term. Do not intersperse prose inside equations.

3. **Be precise about what is learned vs computed vs fixed.** For every parameter or weight, state whether it is:
   - Fixed (e.g., always 1)
   - Learned (optimized during training, static at inference)
   - Input-dependent (computed dynamically from the input)

4. **Count new parameters.** When a method introduces new parameters, state exactly how many and their shapes.

5. **State computational cost.** Mention time and memory complexity in terms of the declared notation.

6. **No hedging on things the paper is clear about.** If the paper states something definitively, relay it definitively.

7. **Flag genuine ambiguities.** If the paper is vague or imprecise about something, say so rather than guessing.

8. **When comparing methods from the paper**, use a consistent notation across all methods rather than switching notation per method.

#### Method Reconstruction

1. **Write for reimplementation-level understanding.** A reader should be able
   to mentally execute the method without reopening the paper. Include the
   actual score construction, normalization, selection rule, state update,
   objective, training stages, and inference path. Naming a component is not a
   substitute for explaining it.

2. **Trace one example through the system.** In prose, explain what happens to
   one representative token, example, expert, query, or state. Use this trace to
   expose ordering and dependencies that a bag-of-components description hides.

3. **Separate mechanism from motivation.** State what the code computes before
   describing why the authors believe it works. Clearly label mechanistic
   evidence, theoretical guarantees, and hypotheses as different kinds of
   claims.

4. **Cover train/test differences.** State which components exist only during
   training, which supervision is required, how inference is initialized, and
   whether budgets, thresholds, or routing rules change at evaluation time.

5. **Explain edge cases.** Include forced selections, padding, fallbacks,
   clipping, empty groups, maximum budgets, over-length inputs, and other rules
   without which the method is underspecified.

#### Claim Reconstruction

1. **State the central claims explicitly.** Separate claims about benchmark
   quality, efficiency, causality/mechanism, scaling, generalization, and theory.
   Do not hide them inside a method description.

2. **Preserve assumptions and quantifiers.** A result on two model families or
   synthetic tasks is not a universal LLM claim. A theorem under bounded inputs
   or idealized attention must retain those conditions.

3. **Connect claims to evidence.** Identify which theorem, result, or ablation
   supports each claim. If evidence is correlational or indirect, label it so.

4. **Separate author interpretation from demonstrated result.** Explain the
   proposed mechanism, then state whether it is established by intervention,
   ablation, theorem, correlation, visualization, or conjecture.

5. **Explain why the claim matters.** Relate it to the baseline's failure and
   indicate what research or engineering decision would change if the claim is
   correct.

#### Evaluation Interpretation

1. **Every key result needs a controlled comparison.** Name the model, dataset,
   baseline, metric, exact values or delta, and what is held fixed: parameter
   count, active FLOPs, training tokens, wall time, memory, or inference budget.

2. **Say what the result proves.** End each key-figure item with one sentence
   explaining the supported conclusion. Also state what it does not prove when
   a tempting broader interpretation is unsupported.

3. **Include decisive ablations and negative results.** A benchmark table alone
   rarely establishes the proposed mechanism. Report ablations that remove the
   claimed causal component, scaling failures, regressions, and domains where
   the method does not help.

4. **Do not conflate resource measures.** Training tokens are not FLOPs; FLOPs
   are not latency; average bitrate is not arithmetic precision; parameter count
   is not active memory. Preserve the exact resource controlled by the paper.

5. **Prefer absolute values plus deltas.** "Improves by 20%" is ambiguous unless
   identified as relative or absolute. Give baseline and method values whenever
   the paper reports them.

#### Final Quality Gate

Before considering a summary complete, verify all of the following:

- A reader can reproduce the data flow and training loss from the Methods section.
- A reader can enumerate the paper's central claims, assumptions, and evidence.
- Every symbol in an equation has a shape/domain and provenance.
- Every added parameter has a count or an explicit explanation of why the paper
  does not permit an exact count.
- Complexity is compared with the same baseline and includes practical overheads.
- Each Key Figures item contains setup, number, interpretation, and limitation.
- The Notes section captures failures and ambiguities rather than repeating the abstract.
- No paragraph could be pasted unchanged into a generic summary of a neighboring paper.

### Part 8: Repository completion audit

Run `.agents/skills/read-arxiv-paper/scripts/audit_records.sh . <request-manifest>`
before reporting completion. A request manifest is mandatory for both single
papers and batches; omit the second argument only when intentionally auditing
the repository outside a paper-reading request. Also manually verify the user's
requested inventory against the manifest and its output.

Completion requires, for every requested paper:

- exactly one canonical URL mapping in `papers/ids.jsonl`;
- exactly one matching `papers/summaries/<Stable-ID>.org`;
- a retained source bundle when obtainable;
- one Tectonic compilation attempt and correctly named PDF when successful;
- all seven summary headings exactly once and no replacement top-level schema;
- no forbidden LaTeX commands;
- no orphan factoid IDs or broken relative links;
- `git diff --check` passing.

The script checks structural integrity, not scientific truth. Perform a final
source audit after it passes: replay the Methods data flow against the equations,
check every central claim against its cited table/theorem/ablation, and verify
every reported number in the source. In a delegated batch, the coordinator must
personally source-check one full summary per worker plus every record flagged as
ambiguous. Do not approve prose merely because it satisfies the template.

Do not mark a batch complete because all titles were identified, because a chat
survey was delivered, or because first drafts exist. Completion is proven only
by the inventory-to-artifact audit.

### Part 9: Commit and publish the paper record

After the completion audit and final source audit pass, commit the request-owned records with the subject prefix `create(paper):`. Use the records repository and publication route in **Workspace setup**, inspect the staged diff and verify the published revision.
