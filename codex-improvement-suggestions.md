# Improvement Suggestions

- **`README.md:47-54` & `SETUP_GUIDE.md:25-33`** – Quick start instructions only copy `.claude/commands`, but several commands reference `.claude/docs`, `.claude/checklists`, and `scripts/validate-context.sh`. Users following the docs verbatim will miss required assets, causing `/validate-context` to fail immediately and leaving documentation links broken.
  - *Impact:* New installations start in a broken state for validation and lose the deep command documentation that the commands link to.
  - *Recommendation:* Update both guides to either instruct copying the entire `.claude/` directory (plus `scripts/` if needed) or explicitly list every required directory so all referenced assets exist in new projects.

- **`README.md:65-76`** – The "What Gets Created" tree omits `context/.context-config.json` as well as the `artifacts/` directories that `/init-context` and `/migrate-context` set up.
  - *Impact:* Users reviewing the README underestimate what the setup commands will create and may delete "mysterious" artifact directories, breaking later workflows.
  - *Recommendation:* Expand the tree to include the config file and the artifact subdirectories the commands establish.

- **`.claude/commands/init-context.md:32-36`** – The `find` expression mixing `-maxdepth 0` with `-o -path "*/.claude"` lacks parentheses, so it walks the entire subtree and the unused `CLAUDE_DIRS` variable suggests leftover logic.
  - *Impact:* False positives (and slower startup) when nested `.claude` folders exist elsewhere in the project tree, confusing users with unwarranted warnings.
  - *Recommendation:* Wrap the predicates (e.g., `find "$CURRENT_DIR" -maxdepth 3 -type d -name '.claude'`) and drop unused variables so only relevant directories are reported.

- **`.claude/commands/update-context-system.md:121-126`** – The download step lacks error handling; if `curl` fails (offline, GitHub hiccup), the command proceeds with an empty zip.
  - *Impact:* Subsequent copy steps overwrite commands with nothing, effectively deleting the toolkit.
  - *Recommendation:* Add `--fail` and explicit status checks (e.g., abort if the zip is missing or zero bytes) before continuing.

- **`.claude/commands/update-context-system.md:170-182`** – The command tries to recover the project root with `cd -`, which only works if the previous command changed directories. In fresh shells this prints "OLDPWD not set" and leaves the script in `/tmp`.
  - *Impact:* The backup and copy steps then run in the wrong directory, so no files are updated (or worse, foreign paths get modified).
  - *Recommendation:* Capture `PROJECT_ROOT=$(pwd)` before the `/tmp` work and later `cd "$PROJECT_ROOT"` so the path is deterministic.

- **`scripts/validate-context.sh:144-158`** – Incrementing `INVALID_SESSIONS` inside a pipeline (`echo | while`) happens in a subshell, so the counter stays zero even when invalid JSON is found.
  - *Impact:* Corrupted session JSON files pass validation with a false "✅" report.
  - *Recommendation:* Use a loop that preserves shell state (e.g., `while read -r ...; do ...; done < <(find ...)`) or accumulate results in an array before iterating.

- **`scripts/validate-context.sh:217-229`** – The slash-command check only covers four files, missing `quick-save-context`, `migrate-context`, `export-context`, `validate-context`, and `update-context-system` itself.
  - *Impact:* Missing or renamed commands slip through validation unnoticed, undermining the tool’s integrity checking.
  - *Recommendation:* Extend the list to all nine commands (or derive it dynamically) so the script reflects current expectations.

- **`.claude/commands/validate-context.md:21-30`** – The command description promises section-level validation and task completeness checks that the script never performs.
  - *Impact:* Users expect deeper guarantees than they actually receive, reducing trust in the health score.
  - *Recommendation:* Either expand `scripts/validate-context.sh` to implement those checks or scale back the claims in the command doc to match current functionality.
