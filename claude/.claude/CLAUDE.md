## Behavior
- Be direct and concise. Skip preamble. Match response length to task complexity.
- Think before acting: explore → plan → implement → verify.
- Never modify tests to match implementation. Fix the implementation to pass tests.
- If tests seem wrong, explain why before changing them.
- Batch related edits into single operations. Don't touch unrelated code.
- Commit after each logical change with a clear message.
- Express problems in their simplest possible form, taking care to get the details right.

## Context Efficiency
- Use `grep -rn` or `find` before reading entire files.
- Never read node_modules/, .git/, dist/, build/, .next/, coverage/, __pycache__/.
- Use the gh CLI tool when you need info about PRs or issues.
- Prefer CLI tools over MCP servers when possible (lower token cost).
- When exploring a large codebase, summarize findings — don't dump raw file contents.
- Prefer uv run python over raw python calls.

## Code Quality
- Handle errors explicitly. No silent catches.
- Use correct type annotations, and check your work with typecheckers. Prefer composition over inheritance.
- Write code that reads top-to-bottom without jumping around.
- Code should be easy to maintain. Use the least amount of abstraction possible.
