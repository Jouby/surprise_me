-- Verifies that a creator_token matches a surprise id.
-- Returns true if valid, false otherwise.
create or replace function verify_creator_token(p_id uuid, p_token uuid)
returns boolean language plpgsql security definer as $$
begin
  return exists (
    select 1 from surprises where id = p_id and creator_token = p_token
  );
end;
$$;
