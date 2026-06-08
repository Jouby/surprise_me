-- ── Migration : add 'scratch_game' to surprise_elements.type ────────────────
-- Run this in the Supabase SQL Editor.
--
-- Si la migration supabase_migration_motus_game.sql a déjà été appliquée,
-- la contrainte actuelle autorise :
--   ('text', 'image', 'date', 'location', 'word_game', 'puzzle', 'motus_game')
-- Cette migration ajoute 'scratch_game'.

alter table surprise_elements
  drop constraint if exists surprise_elements_type_check;

alter table surprise_elements
  add constraint surprise_elements_type_check
  check (
    type in (
      'text',
      'image',
      'date',
      'location',
      'word_game',
      'puzzle',
      'motus_game',
      'scratch_game'
    )
  );
