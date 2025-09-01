defmodule HachiwareWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: Application.compile_env!(:hachiware, :ash_domains),
    open_api: "/open_api"
end
