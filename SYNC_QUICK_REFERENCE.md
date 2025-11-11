# Sync Quick Reference

Quick command reference for syncing your fork with upstream.

## Current Configuration

- **Origin (Your Fork)**: `https://github.com/ramkrsna/template-agent.git`
- **Upstream**: `https://github.com/redhat-data-and-ai/template-agent.git`
- **Main Branch**: `main`

## Quick Commands

### Sync Fork (Recommended)
```bash
make sync-upstream
```

### Interactive Sync Script
```bash
./sync-upstream.sh
```

### Manual Sync
```bash
git fetch upstream
git merge upstream/main
git push origin main
```

### Check Sync Status
```bash
git fetch upstream
git log HEAD..upstream/main --oneline
```

### View Remotes
```bash
git remote -v
```

## Typical Workflow

1. **Check current status:**
   ```bash
   git status
   git fetch upstream
   ```

2. **Sync with upstream:**
   ```bash
   make sync-upstream
   ```

3. **Test after sync:**
   ```bash
   make test
   ```

4. **Push changes:**
   ```bash
   git push origin main
   ```

## Common Issues

### Issue: "Upstream remote not found"
**Solution:**
```bash
git remote add upstream https://github.com/redhat-data-and-ai/template-agent.git
```

### Issue: "Uncommitted changes"
**Solution:**
```bash
git stash
make sync-upstream
git stash pop
```

### Issue: "Merge conflicts"
**Solution:**
1. Resolve conflicts in files
2. `git add <resolved-files>`
3. `git commit`
4. `git push origin main`

## See Also

- [FORK_MAINTENANCE.md](./FORK_MAINTENANCE.md) - Detailed guide
- [SETUP_SUMMARY.md](./SETUP_SUMMARY.md) - Setup documentation

