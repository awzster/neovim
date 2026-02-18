# AI_RULES.md

This repository uses AI assistance (e.g., Continue + Ollama).  
These rules are **binding** for any AI-generated changes.

## 1) Tech stack and architecture
- **AngularJS 1.8**
- Prefer **controllerAs `vm`**
- Avoid `$scope` unless strictly necessary (AngularJS internals, watchers, etc.)
- Templates are stored in `view/` and `include/` (project-specific structure)

## 2) Style and formatting
- **Allman braces** (opening brace on the next line)
- Keep formatting consistent with the existing codebase
- No unnecessary reformatting or whitespace-only changes

## 3) UI and text
- **UI strings, placeholders, labels, and comments must be in English only**
- Do not introduce Cyrillic text in UI, placeholders, or comments

## 4) HTML/CSS constraints
- **No inline styles** (`style="..."` is forbidden)
- Put styling in `css/` files (or existing stylesheet locations)
- Keep CSS minimal and scoped; do not add frameworks unless requested

## 5) Dependencies and project scope
- Do **not** add new libraries, frameworks, build tools, or bundlers unless explicitly requested
- Do **not** rename/move files or change folder structure unless explicitly requested
- Avoid “architecture improvements” and broad refactors unless explicitly requested

## 6) Change discipline
- Work in **small, incremental iterations**
- One task → one patch. Avoid mixing unrelated changes
- If something is unclear, do not guess wildly—propose a minimal safe approach

## 8) Example instruction block to prepend in prompts
Use this block at the top of AI requests:

```text
Project: existing AngularJS 1.x app.
Rules: controllerAs vm, Allman braces, UI/comments in English, no inline styles.

Task:
- <one specific change>

Scope:
- Only modify: <file1>, <file2>, ...
- No refactor. No new dependencies. No unrelated edits.

