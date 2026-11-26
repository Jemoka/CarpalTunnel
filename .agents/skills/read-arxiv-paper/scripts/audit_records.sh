#!/usr/bin/env bash
set -eu

workspace=${1:-.}
request_manifest=${2:-}
cd "$workspace"

failures=0

report_failure() {
  printf 'FAIL %s\n' "$1" >&2
  failures=$((failures + 1))
}

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

jq -se 'all(.[]; type == "object" and (.id | type == "string" and length > 0) and (.url | type == "string" and length > 0))' papers/ids.jsonl >/dev/null || report_failure 'invalid row in papers/ids.jsonl'
jq -s -r '.[] | [.id,.url] | @tsv' papers/ids.jsonl | sort > "$tmp_dir/id-map.tsv"
cut -f1 "$tmp_dir/id-map.tsv" > "$tmp_dir/paper-ids.txt"
duplicates=$(cut -f1 "$tmp_dir/id-map.tsv" | uniq -d)
[ -z "$duplicates" ] || report_failure "duplicate IDs in papers/ids.jsonl: $duplicates"
duplicates=$(cut -f2 "$tmp_dir/id-map.tsv" | sort | uniq -d)
[ -z "$duplicates" ] || report_failure "duplicate URLs in papers/ids.jsonl: $duplicates"
jq -s -r '.[] | [.id,.status,.attempted_at,.reason] | @tsv' papers/compilation.jsonl | sort > "$tmp_dir/compilation.tsv"
cut -f1 "$tmp_dir/compilation.tsv" > "$tmp_dir/compilation-ids.txt"
duplicates=$(cut -f1 "$tmp_dir/compilation.tsv" | uniq -d)
[ -z "$duplicates" ] || report_failure "duplicate IDs in compilation registry: $duplicates"
cmp -s "$tmp_dir/paper-ids.txt" "$tmp_dir/compilation-ids.txt" || report_failure 'ID and compilation registries differ'

# A request audit proves the artifacts owned by that immutable manifest. Older
# ignored bundles and PDFs may not be present in every checkout, so they must
# not block an otherwise complete, unrelated request. Omitting the manifest is
# the explicit repository-wide mode and retains the strict all-artifact check.
if [ -z "$request_manifest" ]; then
  cp "$tmp_dir/compilation-ids.txt" "$tmp_dir/artifact-ids.txt"
elif [ -f "$request_manifest" ]; then
  jq -r '.id // empty' "$request_manifest" | sort -u > "$tmp_dir/artifact-ids.txt"
else
  : > "$tmp_dir/artifact-ids.txt"
fi

while IFS=$'\t' read -r paper_id status attempted_at reason; do
  printf '%s\n' "$attempted_at" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' || report_failure "invalid compilation date for $paper_id: $attempted_at"
  [ -n "$reason" ] || report_failure "compilation outcome has no reason: $paper_id"
  case "$status" in
    success)
      if grep -Fqx "$paper_id" "$tmp_dir/artifact-ids.txt"; then
        [ -f "papers/pdf/$paper_id.pdf" ] || report_failure "successful compilation has no PDF: $paper_id"
        if [ -f "papers/pdf/$paper_id.pdf" ]; then
          file "papers/pdf/$paper_id.pdf" | grep -q 'PDF document' || report_failure "successful compilation artifact is not a PDF: $paper_id"
        fi
        [ -d "papers/bundle/$paper_id" ] || report_failure "successful compilation has no retained bundle: $paper_id"
      fi
      ;;
    failed)
      if grep -Fqx "$paper_id" "$tmp_dir/artifact-ids.txt"; then
        [ -d "papers/bundle/$paper_id" ] || report_failure "failed compilation has no retained bundle: $paper_id"
      fi
      ;;
    source_unavailable)
      [ -n "$reason" ] || report_failure "source_unavailable has no reason: $paper_id"
      ;;
    *) report_failure "unknown compilation status for $paper_id: $status" ;;
  esac
done < "$tmp_dir/compilation.tsv"

: > "$tmp_dir/summary-map.tsv"
for summary in papers/summaries/*.org; do
  [ "$(basename "$summary")" = template.org ] && continue

  file_id=$(basename "$summary" .org)
  declared_id=$(sed -n 's/^#+id: //p' "$summary")
  url=$(sed -n 's/^#+url: //p' "$summary")

  [ "$file_id" = "$declared_id" ] || report_failure "summary ID mismatch: $summary"
  printf '%s\t%s\n' "$declared_id" "$url" >> "$tmp_dir/summary-map.tsv"

  while IFS= read -r link; do
    [ -e "$(dirname "$summary")/$link" ] || report_failure "broken summary link: $summary -> $link"
  done < <(grep -o '\[\[file:[^]]*' "$summary" 2>/dev/null | sed 's/^\[\[file://' || true)

  for heading in Notation Novelty Motivation Methods 'Key Figures' Factoids Notes; do
    count=$(grep -Fxc "* $heading" "$summary" || true)
    [ "$count" -eq 1 ] || report_failure "$summary has $count '$heading' headings"
  done

  while IFS= read -r heading; do
    case "$heading" in
      Notation|Novelty|Motivation|Methods|'Key Figures'|Factoids|Notes) ;;
      *) report_failure "unexpected top-level heading in $summary: $heading" ;;
    esac
  done < <(sed -n 's/^\* //p' "$summary")

  if grep -Eq '\\\\!|\\\\;|\\\\,|\\\\quad|\\\\begin\{cases\}|\\\\text\{' "$summary"; then
    report_failure "forbidden LaTeX command in $summary"
  fi
done

sort -o "$tmp_dir/summary-map.tsv" "$tmp_dir/summary-map.tsv"
cut -f1 "$tmp_dir/summary-map.tsv" > "$tmp_dir/summary-ids.txt"
cmp -s "$tmp_dir/id-map.tsv" "$tmp_dir/summary-map.tsv" || report_failure 'papers/ids.jsonl and summary ID/URL maps differ'

if [ -n "$request_manifest" ]; then
  if [ ! -f "$request_manifest" ]; then
    report_failure "missing request manifest: $request_manifest"
  else
    jq -e 'type == "object" and (.id | type == "string" and length > 0) and (.url | type == "string" and length > 0)' "$request_manifest" >/dev/null || report_failure "invalid row in request manifest: $request_manifest"
    jq -s -r '.[] | [.id,.url] | @tsv' "$request_manifest" | sort > "$tmp_dir/request.tsv"
    duplicates=$(cut -f1 "$tmp_dir/request.tsv" | uniq -d)
    [ -z "$duplicates" ] || report_failure "duplicate IDs in request manifest: $duplicates"
    duplicates=$(cut -f2 "$tmp_dir/request.tsv" | sort | uniq -d)
    [ -z "$duplicates" ] || report_failure "duplicate URLs in request manifest: $duplicates"
    while IFS=$'\t' read -r paper_id url; do
      case "$url" in
        https://arxiv.org/abs/*)
          printf '%s\n' "$url" | grep -Eq '^https://arxiv\.org/abs/[0-9]{4}\.[0-9]{4,5}$' || report_failure "noncanonical arXiv URL: $url"
          ;;
        http://*|https://*) ;;
        *) report_failure "noncanonical request URL: $url" ;;
      esac
      grep -Fqx "$paper_id" "$tmp_dir/summary-ids.txt" || report_failure "request paper missing summary: $paper_id"
      grep -Fqx "$paper_id" "$tmp_dir/compilation-ids.txt" || report_failure "request paper missing compilation outcome: $paper_id"
      grep -Fqx "$paper_id"$'\t'"$url" "$tmp_dir/id-map.tsv" || report_failure "request URL/ID differs from registry: $paper_id"
    done < "$tmp_dir/request.tsv"
  fi
fi

while IFS= read -r factoid; do
  factoid_id=$(basename "$factoid" .org)
  printf '%s\n' "$factoid_id" | grep -Eq '^[A-Z][a-z]{2}[0-9]{6}-[a-z0-9_]+$' || report_failure "bad factoid ID: $factoid"

  for heading in one-liner motivation notation methods 'related work and baselines' References notes; do
    count=$(grep -Fxc "* $heading" "$factoid" || true)
    [ "$count" -eq 1 ] || report_failure "$factoid has $count '$heading' headings"
  done

  while IFS= read -r link; do
    [ -e "$(dirname "$factoid")/$link" ] || report_failure "broken factoid link: $factoid -> $link"
  done < <(grep -o '\[\[file:[^]]*' "$factoid" 2>/dev/null | sed 's/^\[\[file://' || true)

  while IFS= read -r paper_id; do
    [ -z "$paper_id" ] && continue
    grep -Fqx "$paper_id" "$tmp_dir/paper-ids.txt" || report_failure "unknown paper reference: $factoid -> @$paper_id"
  done < <(grep -Eo '@[A-Z][A-Za-z]+[0-9]{4}-[A-Za-z0-9_]+' "$factoid" | sed 's/^@//' | sort -u || true)
done < <(find factoids -type f -name '*.org' ! -name template.org ! -name notation.org | sort)

find factoids -type f -name '*.org' ! -name template.org ! -name notation.org -exec basename {} .org \; | sort > "$tmp_dir/factoid-ids.txt"
duplicates=$(uniq -d "$tmp_dir/factoid-ids.txt")
[ -z "$duplicates" ] || report_failure "duplicate factoid IDs: $duplicates"

while IFS= read -r factoid_id; do
  [ -z "$factoid_id" ] && continue
  find factoids -type f -name "$factoid_id.org" | grep -q . || report_failure "orphan factoid reference: $factoid_id"
done < <(
  for summary in papers/summaries/*.org; do
    awk '/^\* Factoids$/{inside=1;next}/^\* Notes$/{inside=0}inside' "$summary"
  done | grep -Eo '[A-Z][a-z]{2}[0-9]{6}-[a-z0-9_]+' | sort -u || true
)

for summary in papers/summaries/*.org; do
  [ "$(basename "$summary")" = template.org ] && continue
  factoid_body=$(awk '/^\* Factoids$/{inside=1;next}/^\* Notes$/{inside=0}inside' "$summary" | sed '/^[[:space:]]*$/d')
  [ "$factoid_body" = '- None recorded separately.' ] && continue
  while IFS= read -r line; do
    printf '%s\n' "$line" | grep -Eq '^- [A-Z][a-z]{2}[0-9]{6}-[a-z0-9_]+$' || report_failure "invalid Factoids entry in $summary: $line"
  done <<EOF
$factoid_body
EOF
done

git diff --check -- .agents/skills/read-arxiv-paper AGENTS.md factoids papers

if [ "$failures" -ne 0 ]; then
  printf 'audit failed with %d issue(s)\n' "$failures" >&2
  exit 1
fi

printf 'paper and factoid record audit passed\n'
