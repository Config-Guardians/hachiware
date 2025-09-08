defmodule Hachiware.Reports.Report do
  use Ash.Resource,
    domain: Hachiware.Reports,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  attributes do
    create_timestamp :created_at do
      primary_key? true
      public? true
    end

    attribute :title, :string do
      allow_nil? false
      public? true
    end

    attribute :report, :string do
      allow_nil? false
      public? true
    end

    attribute :status, :atom do
      constraints one_of: [:open, :closed]
      default :open
      public? true
    end
  end

  actions do
    defaults [:read, create: :*, update: :*]
  end

  json_api do
    type "report"
  end

  postgres do
    table "reports"
    repo Hachiware.Reports.Repo
  end
end
