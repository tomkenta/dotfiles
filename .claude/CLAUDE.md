# External brain

The user's persistent external brain is the Obsidian Vault at
`~/src/github.com/tomkenta/external_brain`.

- At the start of every task, regardless of the current working directory, read the Vault's `CLAUDE.md` and follow its applicable instructions.
- This rule also applies when working in another repository or outside a Git repository.
- When the task depends on the user's personal context, preferences, plans, history, or past decisions, use the context-routing order defined in the Vault instead of scanning the entire Vault.
- Before changing anything in the Vault, read its `AGENTS.md` and obey its shared content, safety, and locking conventions.
- Treat personal and confidential Vault content carefully. Explicit user instructions take precedence over these defaults.

# Skill-ification

Propose turning work into a reusable skill (`.claude/skills/<name>/SKILL.md`) when an
observable signal appears — not when the work merely feels tedious. The signals follow the
user's own rule in the Vault (`wiki/notes/同じ説明を2回したら仕組み化する.md`):

- The same multi-step procedure has been carried out twice.
- The user has asked for the same kind of output twice (a CV, a marketplace listing, a settlement).
- The procedure only works because of knowledge held in this conversation, and the next
  session would have to re-derive it.
- A guard is needed so a known failure does not recur (e.g. writing facts the source does not contain).

How to propose: one or two lines at the end of the task — the skill name, what it would
cover, and the guard it needs. Then stop and let the user decide.

Do not build the skill unasked. Do not propose for genuinely one-off work: an unused skill
is worse than no skill, and proposing on every task turns the signal into noise.
