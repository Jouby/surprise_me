-- ── Migration : add 'puzzle' and 'motus_game' to surprise_elements.type ──────
-- Run this in the Supabase SQL Editor.
--
-- The original CHECK constraint only allowed:
--   ('text', 'image', 'date', 'location', 'word_game')
-- This migration drops the old constraint and replaces it with an updated one
-- that also accepts 'puzzle' and 'motus_game'.

alter table surprise_elements
  drop constraint if exists surprise_elements_type_check;

alter table surprise_elements
  add constraint surprise_elements_type_check
  check (type in ('text', 'image', 'date', 'location', 'word_game', 'puzzle', 'motus_game'));
