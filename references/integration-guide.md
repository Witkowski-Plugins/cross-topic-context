# Cross-Topic Context — Integration Guide

## Problem

Telegram forum groups create separate sessions per topic. When a user switches topics, the agent loses context from the previous topic. This causes repeated information, missed references, and broken continuity.

## Solution

A shared rolling buffer file (`.cross-topic/live-context.md`) that every topic session reads on start and writes to on every substantive reply. Entries auto-prune after 1 hour, keeping the file small and relevant.

## Prerequisites

- OpenClaw workspace with Telegram forum group configured
- Multiple topics in the group
- Agent reads workspace files at session start (standard OpenClaw behavior)

## Setup

1. Install the skill or copy it to `skills/cross-topic-context/`
2. Run: `bash skills/cross-topic-context/scripts/setup.sh`
3. Add the two lines to AGENTS.md (setup script prints them)
4. Restart gateway if needed

## How It Works

```
User messages in Topic A → Agent reads live-context.md → has context from Topics B, C
Agent replies in Topic A → appends summary to live-context.md
User switches to Topic B → Agent reads live-context.md → sees what just happened in Topic A
```

## Entry Format

```
## [HH:MM] Topic Name
One-line summary of decision or action.
```

- Timestamp: ET (or local timezone), 24-hour format
- Topic name: exact match from your topic map
- Summary: one line, captures the decision/action, not the conversation
- Max 15 entries, auto-pruned past 1 hour

## What This Doesn't Do

- Replace CURRENT.md (persistent state) — this is ephemeral (1 hour)
- Replace daily logs (full record) — this is a summary buffer
- Replace compound memory (learning) — this is for real-time flow
- Work across different chat groups — this is per-workspace

## Compatibility

Works with any OpenClaw instance that uses Telegram forum groups. No dependencies on other skills, though it complements compound-memory well.

The skill is agent-driven (the LLM reads/writes the file). No hooks, no cron jobs, no external scripts required during normal operation.
