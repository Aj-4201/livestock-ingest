# livestock-ingest

ETL/ELT entry point for onboarding **external ranches** (the subscription model)
and importing their existing records into the platform, plus bulk loads (e.g.
initial herd, historical health logs).

## Flow

```
source file/API  →  staging tables  →  validation  →  load into operational schema
```

- Raw data lands in a `staging` schema (never touches production tables directly).
- Validation rejects/queues bad rows instead of aborting the whole batch.
- Successful rows are upserted into `livestock-db` tables.

## Layout

```
staging/    DDL for the staging schema (toward livestock-db, kept here while WIP)
mappings/   field mappings per source (CSV/JSON) → platform columns
samples/    example input files
```

## Status

Scaffold only — the loader implementation (TypeScript, matching the agreed
stack) lands once onboarding sources are confirmed with the client.

## Notes

- Everything is **tenant-scoped**: an import targets exactly one `tenant_id`.
- Keep raw dumps out of git (they contain real animal/financial data).
