defmodule Hachiware.Reports.Report do
  use Ash.Resource,
    domain: Hachiware.Reports,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  postgres do
    table "reports"
    repo Hachiware.Reports.Repo
  end

  json_api do
    type "report"
  end

  actions do
    defaults [:read, create: :*, update: :*]
  end

  attributes do
    create_timestamp :created_at do
      primary_key? true
      public? true
    end

    attribute :original_filename, :string do
      allow_nil? false
      public? true
    end

    attribute :patched_content, :string do
      allow_nil? false
      public? true
    end

    attribute :policy_compliance, :struct do
      constraints fields: [
                    violations_detected: [type: :integer, allow_nil?: false],
                    validation_status: [type: :string],
                    policy_file_used: [type: :string]
                  ]

      public? true
    end

    attribute :changes_summary, :struct do
      constraints fields: [
                    total_changes: [type: :integer],
                    changes_detail: [type: {:array, :map}]
                  ]

      public? true
    end

    attribute :violations_analysis, :map do
      constraints fields: [
                    raw_violations: [type: :string]
                  ]

      public? true
    end
  end
end
