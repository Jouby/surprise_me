-- ── Migration : creator_token ────────────────────────────────────────────────
-- Run this in the Supabase SQL Editor.

-- 1. Add creator_token column (existing rows get a random UUID automatically)
alter table surprises
  add column if not exists creator_token uuid not null default gen_random_uuid();

-- 2. RPC: update surprise identity (emoji, title, subtitle, color)
create or replace function update_surprise(
  p_id      uuid,
  p_token   uuid,
  p_emoji   text,
  p_title   text,
  p_subtitle text,
  p_color   text
) returns void language plpgsql security definer as $$
begin
  update surprises
     set emoji    = p_emoji,
         title    = p_title,
         subtitle = p_subtitle,
         color    = p_color
   where id = p_id and creator_token = p_token;
  if not found then
    raise exception 'not_authorized';
  end if;
end;
$$;

-- 3. RPC: delete surprise + cascade elements
create or replace function delete_surprise(
  p_id    uuid,
  p_token uuid
) returns void language plpgsql security definer as $$
begin
  delete from surprises where id = p_id and creator_token = p_token;
  if not found then
    raise exception 'not_authorized';
  end if;
end;
$$;

-- 4. RPC: add an element (verifies ownership of parent surprise)
create or replace function add_surprise_element(
  p_surprise_id uuid,
  p_token       uuid,
  p_type        text,
  p_label       text,
  p_content     text,
  p_unlock_code text,
  p_sort_order  int
) returns uuid language plpgsql security definer as $$
declare
  v_id uuid;
begin
  if not exists (
    select 1 from surprises where id = p_surprise_id and creator_token = p_token
  ) then
    raise exception 'not_authorized';
  end if;

  insert into surprise_elements (surprise_id, type, label, content, unlock_code, sort_order)
  values (p_surprise_id, p_type, p_label, p_content, p_unlock_code, p_sort_order)
  returning id into v_id;

  return v_id;
end;
$$;

-- 5. RPC: update an element (verifies ownership via parent surprise)
create or replace function update_surprise_element(
  p_id          uuid,
  p_token       uuid,
  p_type        text,
  p_label       text,
  p_content     text,
  p_unlock_code text
) returns void language plpgsql security definer as $$
begin
  update surprise_elements se
     set type        = p_type,
         label       = p_label,
         content     = p_content,
         unlock_code = p_unlock_code
    from surprises s
   where se.id = p_id
     and se.surprise_id = s.id
     and s.creator_token = p_token;
  if not found then
    raise exception 'not_authorized';
  end if;
end;
$$;

-- 6. RPC: delete an element (verifies ownership)
create or replace function delete_surprise_element(
  p_id    uuid,
  p_token uuid
) returns void language plpgsql security definer as $$
begin
  delete from surprise_elements se
    using surprises s
   where se.id = p_id
     and se.surprise_id = s.id
     and s.creator_token = p_token;
  if not found then
    raise exception 'not_authorized';
  end if;
end;
$$;
