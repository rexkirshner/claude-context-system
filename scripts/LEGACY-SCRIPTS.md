# Legacy Migration Script

**migrate-to-1-9-0.sh** - Migrates projects from v1.7/v1.8 to v1.9

## Status

This script is for **v1.9 migration only** (not v2.0).

## When to Use

- If you're on v1.7 or v1.8 and want to upgrade to v1.9 first
- Not needed if you're going directly from v1.7/v1.8 to v2.0

## For v2.0 Migration

See [MIGRATION_GUIDE.md](../MIGRATION_GUIDE.md) - manual migration for now, automated in v2.1

## Script Purpose

This script:
- Cleans up legacy v1.7/v1.8 system files
- Updates config version to 1.9.0
- Does NOT migrate user content (only system files)

