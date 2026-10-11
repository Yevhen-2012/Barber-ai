# Збереження записів у Supabase

Бот на Render використовує `DATABASE_URL` зі секретних змінних середовища
сервісу. Локально, якщо цієї змінної немає, записи зберігаються у `leads.json`.

Таблиця: `public.example_bot_leads`. Поля: `id`, `name`, `service`, `created_at`.
Перегляд записів: Supabase → Table Editor → `example_bot_leads`.

Роль `example_bot_writer` має лише SELECT та INSERT для цієї таблиці та
доступ до її послідовності. RLS увімкнено; `anon` і `authenticated` не мають
доступу. Бот не створює таблиць і не змінює схему під час роботи.
Схему для відтворення описано у `supabase.sql` (після створення ролі).

Формат підключення через Session pooler:

```text
postgresql://example_bot_writer.PROJECT_REF:PASSWORD@POOLER_HOST:5432/postgres?sslmode=require
```

Точний `POOLER_HOST` береться з Supabase → Connect → Session pooler.
Пароль має бути percent-encoded, якщо він містить спеціальні символи.
Зберігайте пароль лише у секретних змінних Render; не додавайте його до Git.

Збереження виконується SQL-запитом із параметрами через TLS. Якщо база
недоступна, бот не переключається на тимчасовий файл і не підтверджує запис.
