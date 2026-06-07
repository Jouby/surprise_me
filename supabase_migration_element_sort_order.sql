-- ── Migration : persist sort_order on update_surprise_element ────────────────
-- Run this in the Supabase SQL Editor.
--
-- Adds p_sort_order to the update_surprise_element RPC so that
-- reordering elements in the edit screen is persisted to the database.

create or replace function update_surprise_element(
  p_id          uuid,
  p_token       uuid,
  p_type        text,
  p_label       text,
  p_content     text,
  p_unlock_code text,
  p_sort_order  int
) returns void language plpgsql security definer as $$
begin
  update surprise_elements se
     set type        = p_type,
         label       = p_label,
         content     = p_content,
         unlock_code = p_unlock_code,
         sort_order  = p_sort_order
    from surprises s
   where se.id = p_id
     and se.surprise_id = s.id
     and s.creator_token = p_token;
  if not found then
    raise exception 'not_authorized';
  end if;
end;
$$;
