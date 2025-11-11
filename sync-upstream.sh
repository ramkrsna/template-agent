#!/bin/bash

# Sync script for template-agent fork
# This script helps sync your fork with the upstream repository

set -e

UPSTREAM_REMOTE="upstream"
UPSTREAM_BRANCH="main"
LOCAL_BRANCH="main"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Fork Sync Tool ===${NC}"
echo ""

# Check if upstream remote exists
if ! git remote get-url "$UPSTREAM_REMOTE" &>/dev/null; then
    echo -e "${YELLOW}Upstream remote not found. Adding it...${NC}"
    git remote add "$UPSTREAM_REMOTE" https://github.com/redhat-data-and-ai/template-agent.git
    echo -e "${GREEN}✓ Upstream remote added${NC}"
fi

# Fetch from upstream
echo -e "${GREEN}Fetching latest changes from upstream...${NC}"
git fetch "$UPSTREAM_REMOTE"

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "$LOCAL_BRANCH" ]; then
    echo -e "${YELLOW}Warning: You're not on '$LOCAL_BRANCH' branch. Current branch: $CURRENT_BRANCH${NC}"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}Error: You have uncommitted changes. Please commit or stash them first.${NC}"
    exit 1
fi

# Show what will be merged
echo ""
echo -e "${GREEN}=== Changes to be merged ===${NC}"
COMMITS_AHEAD=$(git rev-list --count "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH"..HEAD 2>/dev/null || echo "0")
COMMITS_BEHIND=$(git rev-list --count HEAD.."$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" 2>/dev/null || echo "0")

echo "Commits ahead of upstream: $COMMITS_AHEAD"
echo "Commits behind upstream: $COMMITS_BEHIND"
echo ""

if [ "$COMMITS_BEHIND" -eq 0 ]; then
    echo -e "${GREEN}✓ Your fork is already up to date!${NC}"
    exit 0
fi

# Show commit summary
echo "Recent upstream commits:"
git log --oneline HEAD.."$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" | head -10
echo ""

# Ask for confirmation
read -p "Merge upstream changes? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Sync cancelled."
    exit 0
fi

# Merge upstream changes
echo ""
echo -e "${GREEN}Merging upstream changes...${NC}"
if git merge "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" --no-edit; then
    echo -e "${GREEN}✓ Successfully merged upstream changes${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Review the changes: git log"
    echo "  2. Test your code: make test"
    echo "  3. Push to your fork: git push origin $LOCAL_BRANCH"
else
    echo -e "${RED}✗ Merge conflicts detected${NC}"
    echo ""
    echo "Please resolve conflicts manually:"
    echo "  1. Check conflicted files: git status"
    echo "  2. Resolve conflicts in the files"
    echo "  3. Stage resolved files: git add <file>"
    echo "  4. Complete merge: git commit"
    echo "  5. Push: git push origin $LOCAL_BRANCH"
    exit 1
fi

