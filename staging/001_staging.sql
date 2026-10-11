-- Staging schema for imported datasets. Applied to the warehouse only.
-- Each import batch is isolated by import_batch_id + tenant_id.
CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.import_batch (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   uuid NOT NULL,
  source      text NOT NULL,        -- 'csv' | 'api' | 'manual'
  entity_type text NOT NULL,        -- 'animals' | 'health_records' | ...
  status      text NOT NULL DEFAULT 'received',
  row_count   integer,
  error_count integer DEFAULT 0,
  started_at  timestamptz NOT NULL DEFAULT now(),
  finished_at timestamptz
);

-- Raw landed rows (jsonb payload, validated later).
CREATE TABLE IF NOT EXISTS staging.staged_row (
  id             bigserial PRIMARY KEY,
  import_batch_id uuid NOT NULL REFERENCES staging.import_batch(id) ON DELETE CASCADE,
  row_number     integer,
  payload        jsonb NOT NULL,
  is_valid       boolean,
  error_message  text,
  loaded         boolean NOT NULL DEFAULT false
);
