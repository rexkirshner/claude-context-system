#!/bin/bash

# migrate-to-1-9-0.sh
# Gracefully migrates from v1.7.0/v1.8.0 to v1.9.0
# Cleans up legacy system files, preserves all user content

set -e

# Color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
CONTEXT_DIR="${BASE_DIR}/context"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Migration: Claude Context System → v1.9.0${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# =============================================================================
# Step 1: Detect Current Version
# =============================================================================

echo -e "${BLUE}📦 Detecting current version...${NC}"
echo ""

CURRENT_VERSION="unknown"
if [ -f "$CONTEXT_DIR/.context-config.json" ]; then
  CURRENT_VERSION=$(grep -m 1 '"version":' "$CONTEXT_DIR/.context-config.json" | cut -d'"' -f4 2>/dev/null || echo "unknown")
fi

echo "   Current version: $CURRENT_VERSION"
echo "   Target version: 1.9.0"
echo ""

# Determine upgrade path
if [[ "$CURRENT_VERSION" == "1.9.0" ]]; then
  echo -e "${GREEN}✅ Already on v1.9.0${NC}"
  echo "   No migration needed"
  echo ""
  exit 0
elif [[ "$CURRENT_VERSION" == "1.8.0" ]]; then
  UPGRADE_PATH="1.8.0 → 1.9.0"
  echo "   Upgrade path: $UPGRADE_PATH"
elif [[ "$CURRENT_VERSION" == "1.7.0" ]]; then
  UPGRADE_PATH="1.7.0 → 1.9.0"
  echo "   Upgrade path: $UPGRADE_PATH (includes v1.8.0 changes)"
else
  UPGRADE_PATH="unknown → 1.9.0"
  echo -e "   ${YELLOW}⚠️  Unknown version, will apply all migrations${NC}"
fi

echo ""

# =============================================================================
# Step 2: Clean Up Legacy System Files (Safe - No User Content)
# =============================================================================

echo -e "${BLUE}🧹 Cleaning up legacy system files...${NC}"
echo ""

CLEANED_FILES=0

# Legacy commands (removed in v1.8.0)
LEGACY_COMMANDS=(
  ".claude/commands/init-context-full.md"
  ".claude/commands/quick-save-context.md"
)

for file in "${LEGACY_COMMANDS[@]}"; do
  if [ -f "$BASE_DIR/$file" ]; then
    echo -e "   ${YELLOW}Removing:${NC} $file (obsolete in v1.8.0)"
    rm "$BASE_DIR/$file"
    ((CLEANED_FILES++))
  fi
done

# v1.9.0: save-context.md is now save-full.md
if [ -f "$BASE_DIR/.claude/commands/save-context.md" ]; then
  if [ ! -f "$BASE_DIR/.claude/commands/save-full.md" ]; then
    echo -e "   ${YELLOW}Renaming:${NC} save-context.md → save-full.md"
    mv "$BASE_DIR/.claude/commands/save-context.md" "$BASE_DIR/.claude/commands/save-full.md"
    ((CLEANED_FILES++))
  else
    echo -e "   ${YELLOW}Removing:${NC} save-context.md (replaced by save-full.md)"
    rm "$BASE_DIR/.claude/commands/save-context.md"
    ((CLEANED_FILES++))
  fi
fi

# Legacy templates (if old structure exists)
if [ -f "$BASE_DIR/templates/CLAUDE.template.md" ] && [ -f "$BASE_DIR/templates/CONTEXT.template.md" ]; then
  echo -e "   ${YELLOW}Removing:${NC} CLAUDE.template.md (replaced by CONTEXT.template.md)"
  rm "$BASE_DIR/templates/CLAUDE.template.md"
  ((CLEANED_FILES++))
fi

if [ $CLEANED_FILES -eq 0 ]; then
  echo "   ✅ No legacy files found (already clean)"
else
  echo ""
  echo "   ✅ Cleaned up $CLEANED_FILES legacy system file(s)"
fi

echo ""

# =============================================================================
# Step 3: Check for User Content Migrations (Suggest Only)
# =============================================================================

echo -e "${BLUE}📋 Checking user content for recommended updates...${NC}"
echo ""

SUGGESTIONS=0

# Check if CLAUDE.md exists (should be CONTEXT.md in v1.8.0+)
if [ -f "$CONTEXT_DIR/CLAUDE.md" ]; then
  if [ ! -f "$CONTEXT_DIR/CONTEXT.md" ]; then
    echo -e "   ${YELLOW}📝 Recommendation:${NC} Rename CLAUDE.md → CONTEXT.md"
    echo "      Your content is preserved, just the filename changed in v1.8.0"
    echo "      Run: mv context/CLAUDE.md context/CONTEXT.md"
    ((SUGGESTIONS++))
  else
    echo -e "   ${YELLOW}ℹ️  Notice:${NC} You have both CLAUDE.md and CONTEXT.md"
    echo "      CONTEXT.md is the new standard (v1.8.0+)"
    echo "      Consider consolidating: context/CLAUDE.md → context/CONTEXT.md"
    ((SUGGESTIONS++))
  fi
fi

# Check if tasks/ directory exists (old v1.7.0 structure)
if [ -d "$CONTEXT_DIR/tasks" ]; then
  echo -e "   ${YELLOW}📝 Recommendation:${NC} Consolidate tasks/ directory into STATUS.md"
  echo "      v1.8.0+ uses STATUS.md as single source for current tasks"
  echo "      Your tasks/next-steps.md and tasks/todo.md content should move to STATUS.md"
  echo "      This is a manual migration - we won't delete tasks/ automatically"
  ((SUGGESTIONS++))
fi

# Check if they have SESSIONS.md with old format (prose vs. structured)
if [ -f "$CONTEXT_DIR/SESSIONS.md" ]; then
  # Check if it has the new structured format (look for "### Changed" section)
  if ! grep -q "### Changed" "$CONTEXT_DIR/SESSIONS.md"; then
    echo -e "   ${YELLOW}📝 Recommendation:${NC} Update SESSIONS.md to structured format"
    echo "      v1.8.0+ uses structured sections (Changed, Problem Solved, Mental Models)"
    echo "      Your existing entries are fine, but new entries should use structured format"
    echo "      See: templates/SESSIONS.template.md for examples"
    ((SUGGESTIONS++))
  fi
fi

if [ $SUGGESTIONS -eq 0 ]; then
  echo "   ✅ User content is up-to-date with v1.9.0 standards"
else
  echo ""
  echo "   ℹ️  Found $SUGGESTIONS recommendation(s) - these are optional but recommended"
  echo "   💡 Your content is safe - we never auto-modify user documentation"
fi

echo ""

# =============================================================================
# Step 4: Update Configuration Version
# =============================================================================

echo -e "${BLUE}⚙️  Updating configuration...${NC}"
echo ""

if [ -f "$CONTEXT_DIR/.context-config.json" ]; then
  # Update version to 1.9.0
  if command -v sed > /dev/null 2>&1; then
    # Backup first
    cp "$CONTEXT_DIR/.context-config.json" "$CONTEXT_DIR/.context-config.json.backup"

    # Update version (works on both macOS and Linux)
    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS
      sed -i '' 's/"version": "[^"]*"/"version": "1.9.0"/' "$CONTEXT_DIR/.context-config.json"
    else
      # Linux
      sed -i 's/"version": "[^"]*"/"version": "1.9.0"/' "$CONTEXT_DIR/.context-config.json"
    fi

    echo "   ✅ Updated .context-config.json version to 1.9.0"
    echo "   💾 Backup saved: .context-config.json.backup"
  else
    echo -e "   ${YELLOW}⚠️  Could not update version automatically${NC}"
    echo "   Please manually update context/.context-config.json:"
    echo '   "version": "1.9.0"'
  fi
else
  echo -e "   ${YELLOW}⚠️  No .context-config.json found${NC}"
  echo "   This is fine if migrating from very old version"
fi

echo ""

# =============================================================================
# Step 5: Migration Summary
# =============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Migration to v1.9.0 Complete${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo "**What Changed:**"
echo ""
echo "System Files:"
if [ $CLEANED_FILES -gt 0 ]; then
  echo "  ✅ Cleaned $CLEANED_FILES legacy file(s)"
else
  echo "  ✅ No legacy files to clean"
fi
echo "  ✅ Configuration updated to v1.9.0"
echo ""

if [ $SUGGESTIONS -gt 0 ]; then
  echo "User Content (Recommendations):"
  echo "  ℹ️  $SUGGESTIONS optional update(s) suggested above"
  echo "  💡 Your content is preserved - apply recommendations manually if desired"
  echo ""
fi

echo "**What's New in v1.9.0:**"
echo ""
echo "Two-Tier Workflow:"
echo "  • /save - Quick update (2-3 min) - use most sessions"
echo "  • /save-full - Comprehensive (10-15 min) - use before breaks/handoffs"
echo ""
echo "Benefits:"
echo "  • 50-60% reduction in overhead"
echo "  • Same context recovery quality"
echo "  • Better developer experience"
echo ""

echo "**Next Steps:**"
echo ""
echo "1. Review recommendations above (if any)"
echo "2. Try the new workflow:"
echo "   /save          # Quick update (most sessions)"
echo "   /save-full     # Comprehensive (before breaks)"
echo "3. See MIGRATION_GUIDE.md for detailed upgrade notes"
echo ""

echo -e "${GREEN}Migration complete! You're now on v1.9.0${NC}"
echo ""

exit 0
