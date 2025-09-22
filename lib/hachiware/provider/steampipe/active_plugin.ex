defmodule Hachiware.Provider.Steampipe.ActivePlugin do
  use Ash.Resource,
    domain: Hachiware.Provider.Steampipe,
    data_layer: Ash.DataLayer.Ets,
    extensions: [AshJsonApi.Resource]

  attributes do
    attribute :provider, :atom do
      primary_key? true
      allow_nil? false

      constraints one_of: [:Aws, :Github]
      public? true
    end
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]

    action :install, :map do
      argument :plugin, :string, allow_nil?: false
      argument :configuration, :string, allow_nil?: false
      validate present([:plugin, :configuration])

      run Hachiware.Provider.Steampipe.SteampipeWrapper
#
# prepare after_action(fn input, _result, _ctx -> 
#         Ash
#       end)
    end
  end

  resource do
    require_primary_key? false
  end

  json_api do
    type "plugin"
    routes do
      base "/plugin"

      route :post, "/", :install
    end
  end
end
