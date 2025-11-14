set SIDECAR_HOST=lmao
del /s /q priv\repo\migrations
del /s /q priv\resource_snapshots\repo\public.reports
mix ash_postgres.generate_migrations updated_schema --domains Hachiware.Reports
