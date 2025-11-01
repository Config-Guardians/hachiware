defmodule Hachiware.Reports.Cloud do
  use Ash.Resource,
    domain: Hachiware.Reports,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  postgres do
    table "cloud"
    repo Hachiware.Reports.Repo
  end

  json_api do
    type "cloud"
  end

  actions do
    defaults [:read, create: :*]

    read :search do
      argument :filter_value, :string do
        allow_nil? false
      end

      filter expr(contains(command, ^arg(:filter_value)))
    end
  end

  attributes do
    create_timestamp :created_at do
      primary_key? true
      public? true
    end

    attribute :command, :string do
      allow_nil? false
      public? true
    end
  end
end

require Protocol

Protocol.derive(Jason.Encoder, Hachiware.Reports.Cloud,
  except: Hachiware.Provider.remove_ash_fields()
)
