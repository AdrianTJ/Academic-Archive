---
name: summarize-changes
description: >
  EXAMPLE SKILL — condense a list of code changes (merged PRs, commits, a changelog)
  into clear, grouped, human-readable notes. Use when the task is to summarize what
  changed for a release, a status update, or a digest. This skill ships as a minimal,
  working illustration of the SKILL.md shape; learn from it, then replace or delete it.
---

# Summarize changes

> **EXAMPLE** — a minimal, real skill included so newcomers can see the shape. Delete it
> (and the `release-notes` agent that composes it) once you've authored your own.

Turn a raw list of changes into notes a human actually wants to read.

## Workflow
1. Group the raw changes by theme (features, fixes, breaking changes, internal) rather
   than listing them in commit order.
2. Rewrite each entry in plain, user-facing language — what changed and why it matters,
   not the implementation detail.
3. Lead with anything breaking or action-required; keep the long tail terse.
4. Drop noise (merge commits, version bumps, formatting-only changes).

## Output
A short, grouped set of notes in Markdown, with breaking/action-required items first and
a one-line summary at the top. Note anything you couldn't categorize rather than guessing.
