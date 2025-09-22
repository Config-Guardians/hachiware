defmodule Hachiware.Provider.Steampipe do
  use Ash.Domain,
    extensions: [AshJsonApi.Domain]

  resources do
    resource Hachiware.Provider.Steampipe.ActivePlugin
  end
end
