# factoids
Please organize the factoids based on topic in this folder. For the format, use Emacs Org. For deduplication, name each factoid:

`MMMddyyyy-factoid_title`

and place it into the apporpriate topic. If a good topic does not exist, then make a folder for it. Please stick to `template.org` for the template. Follow the below workflow

The filename is the factoid's ID. Do not reuse a paper Stable Contribution ID
as a factoid ID. For example, a factoid created on July 19, 2026 should be named
`Jul192026-description_of_the_reusable_claim.org`.

Before creating a factoid:

1. Search all existing factoid titles, prose, and references for the same claim.
2. Prefer the most specific existing topic directory. For example, an attention
   mechanism belongs under `architecture/attention/`, not directly under
   `architecture/`; an MoE routing rule belongs under the existing MoE topic.
3. Create a factoid only when the claim or method is useful independently of the
   source paper. Paper-specific benchmark numbers and restatements of an
   abstract normally remain in the paper summary.
4. Add the factoid ID to a paper summary only after the factoid file exists.

## quality bar

Factoids should be precise, high-taste, scientifically accurate, and concise.

- State one reusable claim, not a paper recap or a cluster of observations.
- Scope the claim to its assumptions and evidence; distinguish identity,
  mechanism, empirical result, and conjecture.
- Prefer an equation or operational recipe over explanatory filler.
- Keep each section to the minimum needed; one short paragraph is usually
  enough. State each qualification once.
- Put benchmark inventories and extended evidence in the paper summary.
- Delete a weak factoid rather than preserving it for completeness.

Before finishing, reread the cited summary and try to falsify every sentence.
Remove unsupported causality, universality, novelty, and efficiency claims.

## step 1: fix notation
1. **Observe notation.** Consult `notation.org` if it exists. Create it when there is a shared convention to record. Add to it if its something that you think future/related work will keep using. This helps standardize conventions across the factoid library.
2. **Declare a shared notation block.** Before writing any math, state all shared symbols, their shapes, and their value domains. Example:
   - $x^{(l)}(t) \in \mathbb{R}^d$: hidden state at layer $l$, token $t$
   - $L$: total layers
   - $d$: hidden dimension
   - $T$: sequence length

## step 2: write
Copy `template.org` and write a factoid, place it into the apporpriate folder.
Use the terse style above; a simple factoid should be quickly scannable.

## step 3: find related work
Grep for common keywords in your factoid across the factoid library and add to your related work and baselines section. If a factoid is added which has notation which contradicts other factoids, prefer the other factoid's notation and unify yours unless there's a really good reason. Edit `notation.org` if needed.

## step 4: validate the record

Before finishing:

1. Confirm the basename matches `^[A-Z][a-z]{2}[0-9]{6}-[a-z0-9_]+$`.
2. Confirm every section in `template.org` appears exactly once.
3. Resolve every `[[file:...]]` link relative to the containing factoid.
4. Confirm every `@PaperID` is a Stable Contribution ID in
   `papers/ids.jsonl`.
5. Confirm every factoid ID named by a paper summary has a corresponding file.
6. Run `git diff --check`.

Do not leave placeholder factoid IDs in summaries. If a proposed factoid is not
worth creating, write `- None recorded separately.` in the summary instead.
