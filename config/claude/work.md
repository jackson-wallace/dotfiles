git branch names should always be "wwallace/<concise task description with no details>"

PR titles use conventional-commit types, which witness reads to release: `major:`/`minor:`/`patch:` (optionally `minor(<scope>):`) bump the version; `chore:`/`docs:` don't.

`GLOSSARY.md` and `docs/adr/` are globally gitignored, so committed files and PR bodies state the reason inline instead of citing them (an ADR number, an ADR path, the glossary).
