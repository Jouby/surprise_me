-- ── Migration : masquer creator_token via privilèges colonne ────────────────
-- Run this in the Supabase SQL Editor.
--
-- PostgreSQL supporte les privilèges au niveau colonne. En révoquant SELECT
-- sur creator_token pour les rôles anon et authenticated, la colonne ne sera
-- plus jamais retournée — même avec SELECT *, même si le client la demande
-- explicitement. Les RPCs (security definer) continuent d'y accéder
-- normalement car ils s'exécutent sous le rôle postgres.

REVOKE SELECT (creator_token) ON surprises FROM anon;
REVOKE SELECT (creator_token) ON surprises FROM authenticated;
