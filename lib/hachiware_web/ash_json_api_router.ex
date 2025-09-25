defmodule HachiwareWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [Hachiware.Reports, Hachiware.Provider.Steampipe],
    open_api: "/open_api"
end
