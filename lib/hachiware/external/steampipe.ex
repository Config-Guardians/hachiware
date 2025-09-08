defmodule Hachiware.External.Steampipe do
  use Ash.Resource,
    domain: Hachiware.External,
    extensions: [AshJsonApi.Resource]

  attributes do
    # attribute :message, :string do
    #   allow_nil? false
    #   public? true
    # end

    # attribute :configuration, :string do
    #   allow_nil? false
    # end
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]

    action :install, :map do
      argument :plugin, :string, allow_nil?: false
      argument :configuration, :string, allow_nil?: false
      run Hachiware.External.SteampipeWrapper
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
