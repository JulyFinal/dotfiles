# Repository guidance

## Issues and specs

Use local Markdown under `.scratch/<feature-slug>/`:

- Spec: `spec.md`.
- One implementation issue per `issues/NN-slug.md`, numbered from `01`; never combine tickets in one file.
- Record triage as a `Status:` line near the top. Append conversation under `## Comments`.
- When a skill says publish to the issue tracker, create a file in this local structure.
- When fetching a ticket, read the path or issue number supplied by the user.

Triage labels use the default mattpocock/skills vocabulary:

| Status | Meaning |
| --- | --- |
| `needs-triage` | Maintainer evaluation needed |
| `needs-info` | Waiting for information |
| `ready-for-agent` | Fully specified; agent can implement |
| `ready-for-human` | Human implementation needed |
| `wontfix` | Will not be actioned |

For wayfinding, use `.scratch/<effort>/map.md` and one child per `issues/NN-slug.md`.
Record dependencies as `Blocked by: NN, NN`. Select the first open, unblocked, unclaimed ticket by number.
Set `Status: claimed` when starting; append the result under `## Answer`, set `Status: resolved`, and update the map when done.

## Domain context

This is a single-context repository. Before exploring, read root `CONTEXT.md` and relevant decisions
under `docs/adr/` when they exist; otherwise proceed silently. Domain-modeling skills create them lazily.
Use the glossary's terms, avoid explicitly rejected synonyms, and reconsider or flag missing terminology
for domain modeling. Surface conflicts with an ADR instead of silently overriding it.
