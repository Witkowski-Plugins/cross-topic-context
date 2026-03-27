#!/bin/bash
# setup.sh — Cross-Topic Context Setup
# Creates the data folder and copies the starter template.
# Run once after installing the skill.
#
# Usage: bash skills/cross-topic-context/scripts/setup.sh [workspace-path]
#
# Default workspace: ~/.openclaw/workspace

set -euo pipefail

WORKSPACE="${1:-$HOME/.openclaw/workspace}"
SKILL_DIR="$WORKSPACE/skills/cross-topic-context"
DATA_DIR="$WORKSPACE/.cross-topic"

echo "🔗 Cross-Topic Context Setup"
echo "============================"
echo ""
echo "Workspace: $WORKSPACE"
echo ""

# Check skill is installed
if [ ! -f "$SKILL_DIR/SKILL.md" ]; then
  echo "❌ Skill not found at $SKILL_DIR"
  echo "   Install first: openclaw skills install --url https://github.com/jwitkowski17/cross-topic-context"
  exit 1
fi

# Create data directory
if [ -d "$DATA_DIR" ]; then
  echo "⚠️  Data folder already exists at $DATA_DIR"
  echo "   Skipping folder creation (won't overwrite existing data)."
  echo ""
else
  mkdir -p "$DATA_DIR"
  echo "✅ Created $DATA_DIR/"
  echo ""
fi

# Copy template (only if file doesn't exist)
if [ -f "$DATA_DIR/live-context.md" ]; then
  echo "   ⏭️  live-context.md already exists, skipping"
else
  cp "$SKILL_DIR/templates/live-context.md" "$DATA_DIR/live-context.md"
  echo "   ✅ Copied live-context.md"
fi

echo ""
echo "============================"
echo "📁 Data folder: $DATA_DIR"
echo ""
echo "Next: add these sections to your workspace files."
echo ""
echo "━━━ Add to AGENTS.md 'Every Session' section ━━━"
echo ""
echo '6. Read `.cross-topic/live-context.md` for cross-topic continuity'
echo ""
echo "━━━ Add to AGENTS.md 'Every Substantive Reply' section ━━━"
echo ""
echo '5. **Cross-topic:** Append one-line entry to `.cross-topic/live-context.md` (prune entries older than 1 hour)'
echo ""
echo "✅ Setup complete. Cross-topic context will flow on the next session."
