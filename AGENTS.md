## Git commits

- Only create commits when explicitly requested.
- Review the diff before committing and include only changes relevant to the task.
- Preserve unrelated user changes. Stage specific files or hunks; avoid `git add .`.
- Never commit credentials, secrets, build outputs, or Xcode user-specific files.
- Run checks appropriate to the change. For app code, build with Xcode’s BuildProject tool. Report any failures or checks that could not run.
- Keep each commit focused on one logical change.
- Use Conventional Commit prefixes: `feat:` for features, `fix:` for bug fixes, `docs:` for documentation, `refactor:` for restructuring without behavior changes, `test:` for tests, and `chore:` for maintenance; add an optional scope when useful (e.g., `fix(quiz): ...`).
- Write a concise, imperative subject, ideally under 72 characters:
  - feat: Add score tracking to the quiz
  - fix: Correct answer selection after restarting
  - docs: Update quiz instructions
- Add a body when useful to explain the reason for the change or important limitations.
- Do not claim tests passed unless they actually ran and passed.
- Do not amend commits, rewrite history, or push unless explicitly requested.
- After committing, report the commit hash, subject, and validation results.
