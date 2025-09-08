defmodule Hachiware.External do
  use Ash.Domain,
    extensions: [AshJsonApi.Domain]

  resources do
    resource Hachiware.External.Steampipe
  end
end
