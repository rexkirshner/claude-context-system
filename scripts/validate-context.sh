#!/bin/bash

# validate-context.sh
# Validates Claude Context System documentation and configuration files
# Exit codes: 0 = pass, 1 = warnings, 2 = errors

set -e

# Color codes for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Counters
ERRORS=0
WARNINGS=0

# Base directory (assume script is in scripts/ directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
CONTEXT_DIR="${BASE_DIR}/context"
CONFIG_DIR="${BASE_DIR}/config"
TEMPLATES_DIR="${BASE_DIR}/templates"

echo "🔍 Validating Claude Context System..."
echo "Base directory: $BASE_DIR"
echo ""

# =============================================================================
# Check 1: Required Documentation Files
# =============================================================================
echo "📄 Checking required documentation files..."

REQUIRED_DOCS=(
  "context/CLAUDE.md"
  "context/PRD.md"
  "context/ARCHITECTURE.md"
  "context/DECISIONS.md"
  "context/CODE_STYLE.md"
  "context/KNOWN_ISSUES.md"
  "context/SESSIONS.md"
  "context/tasks/next-steps.md"
  "context/tasks/todo.md"
)

for doc in "${REQUIRED_DOCS[@]}"; do
  if [ -f "$BASE_DIR/$doc" ]; then
    echo "  ✅ $doc"
  else
    echo -e "  ${RED}❌ Missing: $doc${NC}"
    ((ERRORS++))
  fi
done
echo ""

# =============================================================================
# Check 2: Unresolved Placeholders
# =============================================================================
echo "🔎 Checking for unresolved placeholders..."

PLACEHOLDER_PATTERNS=(
  "\[TODO:"
  "\[PLACEHOLDER"
  "\[FIXME"
  "\[XXX"
  "TODO: Add"
  "TODO: Fill"
  "TODO: Update"
)

PLACEHOLDER_FOUND=0

if [ -d "$CONTEXT_DIR" ]; then
  for pattern in "${PLACEHOLDER_PATTERNS[@]}"; do
    # Use grep to find placeholders, suppress errors if no matches
    matches=$(grep -r "$pattern" "$CONTEXT_DIR" 2>/dev/null || true)
    if [ -n "$matches" ]; then
      if [ $PLACEHOLDER_FOUND -eq 0 ]; then
        echo -e "  ${YELLOW}⚠️  Unresolved placeholders found:${NC}"
        PLACEHOLDER_FOUND=1
      fi
      echo "$matches" | while read -r line; do
        echo -e "    ${YELLOW}$line${NC}"
      done
      ((WARNINGS++))
    fi
  done

  if [ $PLACEHOLDER_FOUND -eq 0 ]; then
    echo "  ✅ No unresolved placeholders"
  fi
else
  echo -e "  ${YELLOW}⚠️  Context directory not found${NC}"
  ((WARNINGS++))
fi
echo ""

# =============================================================================
# Check 3: Configuration File Validation
# =============================================================================
echo "⚙️  Validating configuration files..."

# Check if .context-config.json exists
if [ -f "$CONTEXT_DIR/.context-config.json" ]; then
  # Check if jq is available for JSON validation
  if command -v jq &> /dev/null; then
    if jq empty "$CONTEXT_DIR/.context-config.json" 2>/dev/null; then
      echo "  ✅ .context-config.json is valid JSON"

      # If schema exists, validate against it (requires ajv or similar - skip for basic validation)
      if [ -f "$CONFIG_DIR/context-config-schema.json" ]; then
        echo "  ℹ️  Schema found at $CONFIG_DIR/context-config-schema.json"
        echo "     (Install 'ajv-cli' for full schema validation: npm install -g ajv-cli)"
      fi
    else
      echo -e "  ${RED}❌ .context-config.json is invalid JSON${NC}"
      ((ERRORS++))
    fi
  else
    echo "  ℹ️  .context-config.json found (install 'jq' to validate JSON)"
  fi
else
  echo -e "  ${YELLOW}⚠️  .context-config.json not found${NC}"
  ((WARNINGS++))
fi

# Check state.json if it exists
if [ -f "$CONTEXT_DIR/state.json" ]; then
  if command -v jq &> /dev/null; then
    if jq empty "$CONTEXT_DIR/state.json" 2>/dev/null; then
      echo "  ✅ state.json is valid JSON"
    else
      echo -e "  ${RED}❌ state.json is invalid JSON${NC}"
      ((ERRORS++))
    fi
  else
    echo "  ℹ️  state.json found (install 'jq' to validate)"
  fi
fi

# Check session JSON files if they exist
if [ -d "$CONTEXT_DIR/sessions" ]; then
  SESSION_FILES=$(find "$CONTEXT_DIR/sessions" -name "session-*.json" 2>/dev/null || true)
  if [ -n "$SESSION_FILES" ]; then
    SESSION_COUNT=$(echo "$SESSION_FILES" | wc -l | tr -d ' ')
    if command -v jq &> /dev/null; then
      INVALID_SESSIONS=0
      echo "$SESSION_FILES" | while read -r session_file; do
        if ! jq empty "$session_file" 2>/dev/null; then
          echo -e "  ${RED}❌ Invalid JSON: $session_file${NC}"
          ((INVALID_SESSIONS++))
        fi
      done
      if [ $INVALID_SESSIONS -eq 0 ]; then
        echo "  ✅ All $SESSION_COUNT session JSON files are valid"
      else
        ((ERRORS++))
      fi
    else
      echo "  ℹ️  Found $SESSION_COUNT session JSON files (install 'jq' to validate)"
    fi
  fi
fi
echo ""

# =============================================================================
# Check 4: Template Files
# =============================================================================
echo "📋 Checking template files..."

TEMPLATE_FILES=(
  "templates/CLAUDE.template.md"
  "templates/PRD.template.md"
  "templates/ARCHITECTURE.template.md"
  "templates/DECISIONS.template.md"
  "templates/CODE_STYLE.template.md"
  "templates/KNOWN_ISSUES.template.md"
  "templates/SESSIONS.template.md"
  "templates/next-steps.template.md"
  "templates/todo.template.md"
)

for template in "${TEMPLATE_FILES[@]}"; do
  if [ -f "$BASE_DIR/$template" ]; then
    echo "  ✅ $(basename "$template")"
  else
    echo -e "  ${YELLOW}⚠️  Missing template: $template${NC}"
    ((WARNINGS++))
  fi
done
echo ""

# =============================================================================
# Check 5: Preferences and Schema Files
# =============================================================================
echo "🔧 Checking configuration system..."

if [ -f "$CONFIG_DIR/preferences.yaml" ]; then
  echo "  ✅ preferences.yaml found"
else
  echo -e "  ${YELLOW}⚠️  preferences.yaml not found${NC}"
  ((WARNINGS++))
fi

if [ -f "$CONFIG_DIR/context-config-schema.json" ]; then
  echo "  ✅ context-config-schema.json found"
else
  echo -e "  ${YELLOW}⚠️  context-config-schema.json not found${NC}"
  ((WARNINGS++))
fi

if [ -f "$CONFIG_DIR/state-schema.json" ]; then
  echo "  ✅ state-schema.json found"
else
  echo -e "  ${YELLOW}⚠️  state-schema.json not found${NC}"
  ((WARNINGS++))
fi

if [ -f "$CONFIG_DIR/session-schema.json" ]; then
  echo "  ✅ session-schema.json found"
else
  echo -e "  ${YELLOW}⚠️  session-schema.json not found${NC}"
  ((WARNINGS++))
fi
echo ""

# =============================================================================
# Check 6: Slash Commands
# =============================================================================
echo "⚡ Checking slash commands..."

COMMANDS=(
  ".claude-commands/init-context.md"
  ".claude-commands/save-context.md"
  ".claude-commands/review-context.md"
  ".claude-commands/code-review.md"
)

for cmd in "${COMMANDS[@]}"; do
  if [ -f "$BASE_DIR/$cmd" ]; then
    echo "  ✅ $(basename "$cmd" .md)"
  else
    echo -e "  ${RED}❌ Missing command: $cmd${NC}"
    ((ERRORS++))
  fi
done
echo ""

# =============================================================================
# Summary
# =============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Validation Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo -e "${GREEN}✅ All checks passed!${NC}"
  echo ""
  exit 0
elif [ $ERRORS -eq 0 ]; then
  echo -e "${YELLOW}⚠️  $WARNINGS warning(s) found${NC}"
  echo ""
  echo "Warnings are non-critical but should be addressed."
  exit 1
else
  echo -e "${RED}❌ $ERRORS error(s) found${NC}"
  if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠️  $WARNINGS warning(s) found${NC}"
  fi
  echo ""
  echo "Please fix errors before proceeding."
  exit 2
fi
