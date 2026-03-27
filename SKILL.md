---
name: cross-topic-context
description: "Real-time context bridge across Telegram forum topics. Maintains a rolling buffer of recent decisions, statements, and actions across all topics so every session has full continuity. Use when: (1) session starts in any topic, (2) making a substantive reply in any topic, (3) user references something said in another topic."
---

# Cross-Topic Context

Eliminates the "separate session per topic" problem in Telegram forum groups. Every topic session reads and writes a shared rolling buffer so context flows instantly across topics.

## Architecture

One file, one purpose:

```
.cross-topic/
└── live-context.md    # Rolling buffer. Last ~15 entries. Auto-pruned past 1 hour.
```

If `.cross-topic/` does not exist, create it and initialize `live-context.md` with the template from `templates/`.

## How It Works

### On Every Session Start (any topic)

Before doing anything else, read `.cross-topic/live-context.md`. This gives you full awareness of what just happened in other topics. Treat these entries as trusted context, same as if the user said it directly to you in this session.

### On Every Substantive Reply (any topic)

After writing to daily log and CURRENT.md (per AGENTS.md rules), also append one entry to `.cross-topic/live-context.md`.

A "substantive reply" means any reply involving a decision, task, topic change, preference, correction, or completed work. Not casual acknowledgments.

### Entry Format

```
## [HH:MM] Topic Name
One-line summary of what happened or was decided.
```

Examples:

```
## [14:32] Systems|Workflows
Enabled 5 cron jobs. Alert routing wired to Daily Briefing topic.

## [14:45] Strategy & Revenue
John confirmed $500k Year 1 target. Adjusted quarterly milestones.

## [14:51] Website
Started V2 homepage copy review. John wants hero section rewritten.
```

Rules:
- Timestamp in ET (America/New_York), 24h format
- Topic name must match exactly from the topic map
- One line, two max. Capture the decision or action, not the conversation.
- No file paths, no technical details, no credentials

### Auto-Prune

Before appending a new entry, prune any entries older than 1 hour. To determine age, compare the entry timestamp against current time.

If the file exceeds 15 entries after pruning, remove the oldest entries to stay at 15.

This keeps the file tiny (under 1KB typically) and relevant.

## Quick Reference

| When | Action |
|------|--------|
| Session starts | Read `.cross-topic/live-context.md` |
| Substantive reply | Append entry, prune old entries |
| User references other topic | Context is already loaded from live-context |
| File doesn't exist | Create from template |
| File empty (all pruned) | Normal, means no recent cross-topic activity |

## Integration

### AGENTS.md Addition

Add to the "Every Session" section:

```
6. Read `.cross-topic/live-context.md` for cross-topic continuity
```

Add to the "Every Substantive Reply" section:

```
5. **Cross-topic:** Append one-line entry to `.cross-topic/live-context.md` (prune entries older than 1 hour)
```

### What This Does NOT Replace

- **CURRENT.md** — still the authoritative live state file. Cross-topic context is ephemeral (1 hour). CURRENT.md is persistent.
- **Daily logs** — still the full record of what happened. Cross-topic context is a summary buffer.
- **Compound memory** — still handles corrections, reflections, patterns. Cross-topic context is for real-time flow only.

This skill adds one lightweight layer on top of existing memory. It does not duplicate or replace anything.

## File Size Discipline

| File | Hard Cap |
|------|----------|
| `live-context.md` | 15 entries / 1 hour window |

The file self-prunes. No manual maintenance needed. No heartbeat task required.

## Security Boundaries

Same rules as compound memory:
- Never store credentials, API keys, financial details, health data
- Entries are summaries, not transcripts
- User can request "show cross-topic context" or "clear cross-topic context" at any time

## Graceful Degradation

If `.cross-topic/live-context.md` is missing or empty, proceed normally. This skill enhances continuity but is not required for basic operation. No errors, no warnings, just reduced cross-topic awareness.
