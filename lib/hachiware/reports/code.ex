defmodule Hachiware.Reports.Code do
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

    read :search do
      argument :filter_value, :string do
        allow_nil? false
      end

      filter expr(
               contains(original_filename, ^arg(:filter_value)) or
                 contains(patched_content, ^arg(:filter_value))
             )
    end
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

    attribute :policy_compliance, :map do
      constraints fields: [
                    violations_detected: [type: :integer, constraints: [min: 0]],
                    validation_status: [type: :string],
                    policy_file_used: [type: :string]
                  ]

      public? true
    end

    attribute :changes_summary, :map do
      constraints fields: [
                    total_changes: [type: :integer, constraints: [min: 0]],
                    changes_detail: [
                      type: {:array, :map},
                      constraints: [
                        fields: [
                          type: [type: :string],
                          content: [type: :string],
                          description: [type: :string]
                        ]
                      ]
                    ]
                  ]

      public? true
    end

    attribute :violations_analysis, :map do
      constraints fields: [
                    raw_violations: [type: :string]
                  ]

      public? true
    end

    attribute :validation_details, :map do
      constraints fields: [
                    original_file_validation: [type: :string],
                    patched_file_validation: [type: :string],
                    original_tests_summary: [type: Hachiware.Reports.TestSummary],
                    patched_tests_summary: [type: Hachiware.Reports.TestSummary]
                  ]

      public? true
    end

    attribute :policy_details, :map do
      constraints fields: [
                    policy_file: [type: :string],
                    specific_rules: [type: {:array, :string}]
                  ]

      public? true
    end

    attribute :timing, :map do
      constraints fields: [
                    remediation_start_time: [type: :string],
                    remediation_end_time: [type: :string],
                    total_duration_seconds: [type: :float]
                  ]

      public? true
    end
  end
end

require Protocol
Protocol.derive(Jason.Encoder, Hachiware.Reports.Code, except: [:__meta__])
