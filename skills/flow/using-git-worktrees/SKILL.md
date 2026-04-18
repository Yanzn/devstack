---
name: using-git-worktrees
description: "Use when starting feature work that needs isolation from current workspace, or before executing implementation plans. Creates a git worktree on a new branch with project setup and a clean test baseline."
---

<!--
origin: [SP]
sources:
  - superpowers:using-git-worktrees @ 5.0.7
notes: |
  Direct port with minor adaptations. Namespace rewritten to devstack:flow/*.
  Global worktree path suggestion changed from ~/.config/superpowers/worktrees/
  to ~/.config/devstack/worktrees/.
-->

# Using Git Worktrees

## Overview

Git worktrees create isolated workspaces sharing the same repository — work on multiple branches simultaneously without switching.

**Core principle:** Systematic directory selection + safety verification = reliable isolation.

**Announce at start:** "I'm using `devstack:flow/using-git-worktrees` to set up an isolated workspace."

## Directory Selection Process

Follow this priority order:

### 1. Check Existing Directories

```bash
ls -d .worktrees 2>/dev/null     # preferred (hidden)
ls -d worktrees 2>/dev/null      # alternative
```

**If found:** use that directory. If both exist, `.worktrees` wins.

### 2. Check CLAUDE.md

```bash
grep -i "worktree.*director" CLAUDE.md 2>/dev/null
```

**If preference specified:** use it without asking.

### 3. Ask User

If no directory exists and no CLAUDE.md preference:

```
No worktree directory found. Where should I create worktrees?

1. .worktrees/ (project-local, hidden)
2. ~/.config/devstack/worktrees/<project-name>/ (global location)

Which would you prefer?
```

## Safety Verification

### For Project-Local Directories (.worktrees or worktrees)

**MUST verify directory is ignored before creating the worktree:**

```bash
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```

**If NOT ignored:**

1. Add the directory to `.gitignore`
2. Commit the change
3. Proceed with worktree creation

**Why critical:** prevents accidentally committing worktree contents into the repository.

### For Global Directory (~/.config/devstack/worktrees)

No `.gitignore` verification needed — outside the project entirely.

## Creation Steps

### 1. Detect Project Name

```bash
project=$(basename "$(git rev-parse --show-toplevel)")
```

### 2. Create Worktree

```bash
case $LOCATION in
  .worktrees|worktrees)
    path="$LOCATION/$BRANCH_NAME"
    ;;
  ~/.config/devstack/worktrees/*)
    path="~/.config/devstack/worktrees/$project/$BRANCH_NAME"
    ;;
esac

git worktree add "$path" -b "$BRANCH_NAME"
cd "$path"
```

### 3. Run Project Setup

Auto-detect and run:

```bash
# Node.js
[ -f package.json ] && npm install

# Rust
[ -f Cargo.toml ] && cargo build

# Python
[ -f requirements.txt ] && pip install -r requirements.txt
[ -f pyproject.toml ] && poetry install

# Go
[ -f go.mod ] && go mod download

# Java / Gradle
[ -f gradlew ] && ./gradlew build -x test

# Java / Maven
[ -f pom.xml ] && mvn -B -DskipTests install

# Swift / Xcode
[ -f Package.swift ] && swift build
```

### 4. Verify Clean Baseline

Run tests to ensure the worktree starts clean. Use the project-appropriate command:

```bash
npm test / cargo test / pytest / go test ./... / ./gradlew test / mvn test / swift test
```

**If tests fail:** report failures, ask whether to proceed or investigate. Don't assume.

**If tests pass:** report ready.

### 5. Report Location

```
Worktree ready at <full path>
Tests passing (<N> tests, 0 failures)
Ready to implement <feature-name>
```

## Quick Reference

| Situation | Action |
|---|---|
| `.worktrees/` exists | Use it (verify ignored) |
| `worktrees/` exists | Use it (verify ignored) |
| Both exist | Use `.worktrees/` |
| Neither exists | Check CLAUDE.md → ask user |
| Directory not ignored | Add to `.gitignore` + commit |
| Tests fail during baseline | Report failures + ask |
| No package.json/Cargo.toml/etc. | Skip dependency install |

## Common Mistakes

**Skipping ignore verification** → worktree contents get tracked, pollute git status. **Fix:** always `git check-ignore` before creating project-local worktree.

**Assuming directory location** → inconsistency, violates project conventions. **Fix:** follow priority — existing > CLAUDE.md > ask.

**Proceeding with failing tests** → can't distinguish new bugs from pre-existing. **Fix:** report failures, get explicit permission.

**Hardcoding setup commands** → breaks on different stacks. **Fix:** auto-detect from project files.

## Red Flags

**Never:**
- Create worktree without verifying it's ignored (project-local)
- Skip baseline test verification
- Proceed with failing tests without asking
- Assume directory location when ambiguous
- Skip CLAUDE.md check

**Always:**
- Follow directory priority: existing > CLAUDE.md > ask
- Verify ignored for project-local
- Auto-detect and run project setup
- Verify clean test baseline

## Integration

**Called by:**
- `devstack:flow/brainstorming` — REQUIRED when design is approved and implementation follows
- `devstack:flow/subagent-driven-development` — REQUIRED before executing any tasks
- `devstack:flow/executing-plans` — REQUIRED before executing any tasks

**Pairs with:**
- `devstack:flow/finishing-a-development-branch` — REQUIRED for cleanup after work is complete
