defmodule Hachiware.Reports.Command do
  use Ash.Resource,
    domain: Hachiware.Reports,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  postgres do
    table "command"
    repo Hachiware.Reports.Repo
  end

  json_api do
    type "command"
  end

  actions do
    defaults [:read, create: :*]

    read :search do
      argument :filter_value, :string do
        allow_nil? false
      end

      pagination keyset?: true, offset?: true

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
