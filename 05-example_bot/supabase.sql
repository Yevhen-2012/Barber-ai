-- Run as a database administrator after provisioning example_bot_writer.
-- The login password belongs only in Render's secret environment variables.
create table if not exists public.example_bot_leads (
    id bigint generated always as identity primary key,
    name text not null check (length(btrim(name)) between 1 and 200),
    service text not null check (length(btrim(service)) between 1 and 500),
    created_at timestamptz not null default now()
);

alter table public.example_bot_leads enable row level security;
revoke all on public.example_bot_leads from public, anon, authenticated;
grant usage on schema public to example_bot_writer;
grant select, insert on public.example_bot_leads to example_bot_writer;
grant usage on sequence public.example_bot_leads_id_seq to example_bot_writer;

create policy example_bot_insert on public.example_bot_leads
    for insert to example_bot_writer with check (true);
create policy example_bot_select on public.example_bot_leads
    for select to example_bot_writer using (true);
