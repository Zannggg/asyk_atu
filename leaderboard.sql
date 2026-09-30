create table if not exists public.scores (
  id bigint generated always as identity primary key,
  name text not null check (char_length(name) between 1 and 16),
  mode text not null check (mode in ('free','ch','cu')),
  score int not null check (score between 0 and 100000),
  round int not null default 1 check (round between 1 and 1000),
  created_at timestamptz not null default now()
);
alter table public.scores enable row level security;
create policy "read scores" on public.scores for select to anon using (true);
create policy "add scores" on public.scores for insert to anon with check (true);
create index if not exists scores_mode_score on public.scores (mode, score desc);

-- права доступа для публичного ключа (на случай, если Data API не выдал их автоматически)
grant usage on schema public to anon, authenticated;
grant select, insert on table public.scores to anon, authenticated;
