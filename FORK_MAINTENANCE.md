# Fork Maintenance Guide

This guide helps you keep your fork of `template-agent` synchronized with the upstream repository (`redhat-data-and-ai/template-agent`).

## Quick Start

### Initial Setup

If you haven't already set up the upstream remote:

```bash
git remote add upstream https://github.com/redhat-data-and-ai/template-agent.git
git fetch upstream
```

### Sync Your Fork

**Option 1: Using the Makefile target (Recommended)**
```bash
make sync-upstream
```

**Option 2: Using the sync script**
```bash
./sync-upstream.sh
```

**Option 3: Manual sync**
```bash
git fetch upstream
git merge upstream/main
git push origin main
```

## Sync Strategies

### 1. Simple Merge (Default)

This is the simplest approach and preserves your commit history:

```bash
git checkout main
git fetch upstream
git merge upstream/main
git push origin main
```

**Pros:**
- Simple and safe
- Preserves full history
- Easy to track what came from upstream

**Cons:**
- Creates merge commits
- History can become cluttered over time

### 2. Rebase Strategy

For a cleaner history, you can rebase your changes on top of upstream:

```bash
git checkout main
git fetch upstream
git rebase upstream/main
git push origin main --force-with-lease
```

**⚠️ Warning:** Only use rebase if you haven't pushed your changes yet, or if you're comfortable with force-pushing.

**Pros:**
- Clean, linear history
- Easier to see changes

**Cons:**
- Rewrites history (requires force push)
- Can be complex if you have many commits

### 3. Sync with Custom Changes

If you have local changes you want to keep:

```bash
# Stash your changes
git stash

# Sync with upstream
git fetch upstream
git merge upstream/main

# Reapply your changes
git stash pop

# Resolve any conflicts, then commit
git add .
git commit -m "Merge upstream and apply custom changes"
```

## Conflict Resolution

If you encounter merge conflicts during sync:

1. **Identify conflicted files:**
   ```bash
   git status
   ```

2. **Open conflicted files** and look for conflict markers:
   ```
   <<<<<<< HEAD
   Your changes
   =======
   Upstream changes
   >>>>>>> upstream/main
   ```

3. **Resolve conflicts** by:
   - Keeping your changes
   - Keeping upstream changes
   - Combining both
   - Writing something new

4. **Stage resolved files:**
   ```bash
   git add <resolved-file>
   ```

5. **Complete the merge:**
   ```bash
   git commit
   ```

6. **Push to your fork:**
   ```bash
   git push origin main
   ```

## Best Practices

### 1. Regular Syncing

Sync frequently to avoid large conflicts:
- **Weekly**: If you're actively developing
- **Before starting new features**: Ensure you're working on latest code
- **After upstream releases**: Sync immediately

### 2. Branch Strategy

Keep your `main` branch clean and in sync with upstream:

```bash
# Always sync main first
git checkout main
make sync-upstream

# Create feature branches from synced main
git checkout -b feature/my-feature
```

### 3. Testing After Sync

Always test after syncing:

```bash
make sync-upstream
make test
```

### 4. Commit Messages

When merging upstream, use descriptive commit messages:

```bash
git merge upstream/main -m "chore: sync with upstream (v1.2.3)"
```

## Automated Syncing

### GitHub Actions (Optional)

You can set up automated syncing using GitHub Actions. Create `.github/workflows/sync-upstream.yml`:

```yaml
name: Sync Upstream

on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday
  workflow_dispatch:  # Manual trigger

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Configure Git
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
      
      - name: Add upstream remote
        run: |
          git remote add upstream https://github.com/redhat-data-and-ai/template-agent.git || true
          git fetch upstream
      
      - name: Merge upstream
        run: |
          git checkout main
          git merge upstream/main --no-edit || exit 0
      
      - name: Push changes
        run: |
          git push origin main
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Contributing Back to Upstream

If you've made improvements you'd like to contribute:

1. **Sync with upstream first:**
   ```bash
   make sync-upstream
   ```

2. **Create a feature branch:**
   ```bash
   git checkout -b feature/my-improvement
   ```

3. **Make your changes** and commit:
   ```bash
   git add .
   git commit -m "feat: add my improvement"
   ```

4. **Push to your fork:**
   ```bash
   git push origin feature/my-improvement
   ```

5. **Create a Pull Request** on GitHub:
   - Go to: https://github.com/redhat-data-and-ai/template-agent
   - Click "New Pull Request"
   - Select "compare across forks"
   - Choose your fork and branch

## Troubleshooting

### "Upstream remote not found"

Add it manually:
```bash
git remote add upstream https://github.com/redhat-data-and-ai/template-agent.git
```

### "Your branch is ahead of origin"

Push your changes:
```bash
git push origin main
```

### "Merge conflicts"

See the [Conflict Resolution](#conflict-resolution) section above.

### "Permission denied" when pushing

Check your Git credentials:
```bash
git remote -v
git config user.name
git config user.email
```

### Upstream branch renamed

If upstream renamed their main branch:
```bash
git remote set-head upstream -a
git fetch upstream
```

## Monitoring Upstream Changes

### Check sync status

```bash
git fetch upstream
git log HEAD..upstream/main --oneline
```

### Watch for releases

- Subscribe to repository notifications on GitHub
- Check the [releases page](https://github.com/redhat-data-and-ai/template-agent/releases)
- Monitor the [changelog](https://github.com/redhat-data-and-ai/template-agent/blob/main/CHANGELOG.md) if available

### Compare branches

```bash
# See what's different
git diff main upstream/main

# See commit differences
git log main..upstream/main --oneline
```

## Additional Resources

- [Git Fork Workflow Guide](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
- [Syncing a Fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork)
- [Resolving Merge Conflicts](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts)

## Quick Reference

| Command | Description |
|---------|-------------|
| `make sync-upstream` | Sync fork with upstream (recommended) |
| `./sync-upstream.sh` | Interactive sync script |
| `git fetch upstream` | Fetch latest changes without merging |
| `git merge upstream/main` | Merge upstream changes |
| `git rebase upstream/main` | Rebase on upstream (advanced) |
| `git remote -v` | List all remotes |
| `git status` | Check sync status |

---

**Need help?** Open an issue or check the [SYNC_QUICK_REFERENCE.md](./SYNC_QUICK_REFERENCE.md) for quick commands.

