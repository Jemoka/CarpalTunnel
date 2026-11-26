---
name: welcome-bootstrap
description: Set up an existing repository for wristing when the user asks to bootstrap a WRIST workspace. Work with them to configure repository references, branch conventions, Gerrit review and the research workflows.
---

# Welcome Bootstrap

Accept a checkout path or repository URL. If neither was supplied, ask which repository the user wants to work on. The template is the source of reusable skills and blank records. The target is the repository the user hands you.

## Inspect and agree on the layout

Read the target’s agent and contributor instructions, Git status, remotes (including push URLs), default branch, worktrees, hook configuration and review tooling. Read any existing WRIST setup first. For a URL, reuse a matching checkout if identified, otherwise clone to an unused directory. Preserve the target's history and local changes.

Give the user a short proposal based on what you found. Ask together about the choices still open and use answers they already supplied.

- **Records and code.** Should the project journals, bets and papers live inside this repo, or in a companion WRIST repo? Which other repos own implementation or serve as read-only references? Record their canonical URLs and roles.
- **Branches and publication.** Confirm the workspace branch, implementation base, topic naming, worktree location, and which remote backs topic branches. The original WRIST uses direct publication of records on `main`, an isolated `bets/<bet-id>` topic per wager, and WIP review of implementation commits. In a single repo, decide how to publish record-only and mixed changes so a direct push cannot bypass required review. Confirm which workflows publish as part of completion.
- **Review.** Agree on post-merge topic and worktree cleanup. For Gerrit, establish the actual project clone URL, trusted web URL, destination branch, reviewer or group, and any WIP, readiness, disclosure or ticket rules. If the project needs onboarding, agree on the host and project owner. Carry out authorized provisioning through that host's supported process if access permits. If an administrator must import the project or grant access, identify the exact missing action and continue independent local setup. Record the chosen route if the user uses another review system.
- **Execution.** For a repo that runs wagers, find its commands for setup, checks, configuration, launch, status, resume, evaluation and result retrieval. Confirm the run location, resource policy, tracking and authoritative artifact store. Record the implementation's own guide where it already defines these. Defer unknown execution details until the first wager that needs them.

## Apply the choices

In the chosen records repo, install the reusable skills from this template, the shared execution contract, blank Org templates, factoid instructions, paper registries and plotting helper. Create missing record directories as needed. On an existing workspace, merge this template’s workflow index and applicable research instructions into the target’s AGENTS.md and inspect differences in same-named files. Preserve all existing records, registry rows, hooks and local conventions. On a repeat invocation, update only the choices that changed.

Maintain a **Workspace setup** section in the records repo's `AGENTS.md`. Include a table with each actual repo's role, canonical URL, checkout locator, base and publication route. Use a portable relative path when available. Document the agreed branch and worktree pattern, review destination and lifecycle, validation commands, and execution guide. If team members need machine-local paths or credentials, document their configuration mechanism and keep personal values out of tracked files. Add a short pointer from the implementation repo when it is separate and the user wants instructions there.

Configure the actual implementation checkout for Gerrit when selected:

1. Preserve the source remote. Add the agreed review remote (conventionally `review`) with `git remote add review <project-clone-url>` if absent. Reuse an equivalent existing remote. Resolve conflicting URLs with the user before repointing one.
2. Inspect `core.hooksPath`, the repository's hook manager and the effective `commit-msg` hook. Integrate the hook served by the selected Gerrit instance at `<web-base>/tools/hooks/commit-msg` using the repo's existing hook mechanism. For an unmanaged checkout, install it executable at the active hooks path. Preserve existing checks. Follow the server's setup instructions for authentication. [Gerrit hook documentation](https://gerrit-review.googlesource.com/Documentation/cmd-hook-commit-msg.html)
3. Document the exact review command with the chosen remote and base, for example `git push review HEAD:refs/for/main%wip`. Write the team's rule for updating a patch set with the same Change-Id and for marking work ready. Bootstrap only configures the route. Publication follows the user's agreed workflow. [Gerrit upload documentation](https://gerrit-review.googlesource.com/Documentation/user-upload.html)

## Verify and hand off

Re-read the effective fetch and push URLs and branch policy in each checkout. For Gerrit, verify that the review project advertises the chosen branch with `git ls-remote --exit-code <review-remote> refs/heads/<base>`. Exercise the effective hook on a disposable commit-message file and check its Change-Id or configured Gerrit Link trailer. This checks read access and hook operation without publishing a change. Follow the workspace SSH connection limit across remote operations.

Verify that the installed skill links, templates, repository references and documented check commands resolve. Inspect the diff against the initial status and report which repo now holds records, where implementation branches start, how to send a change for review, what was verified and any pending server-side setup. Record whether publication permissions were exercised or only read access was verified. Leave scientific records empty on a fresh install.
