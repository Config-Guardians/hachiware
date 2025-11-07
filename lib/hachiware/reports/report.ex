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

    read :search do
      argument :filter_value, :string do
        allow_nil? false
      end

      pagination keyset?: true, offset?: true

      filter expr(
               contains(command, ^arg(:filter_value)) or
                 contains(original_filename, ^arg(:filter_value)) or
                 contains(patched_content, ^arg(:filter_value))
             )
    end
  end

  validations do
    validate absent([:command]) do
      where [attribute_equals(:type, :code)]
    end

    validate present(:command) do
      where [attribute_equals(:type, :cloud)]
    end
  end

  attributes do
    create_timestamp :created_at do
      primary_key? true
      public? true
    end

    attribute :type, :atom do
      allow_nil? false

      constraints one_of: [:code, :cloud]
      public? true
    end

    attribute :command, :string do
      description """
      This field is for cloud reports
      """

      public? true
    end

    attribute :original_filename, :string do
      description """
      This field is for code reports
      """

      public? true
    end

    attribute :patched_content, :string do
      description """
      This field is for code reports
      """

      public? true
    end

    attribute :policy_compliance, :map do
      description """
      This field is for code reports
      """

      constraints fields: [
                    violations_detected: [type: :integer, constraints: [min: 0]],
                    validation_status: [type: :string],
                    policy_file_used: [type: :string]
                  ]

      public? true
    end

    attribute :changes_summary, :map do
      description """
      This field is for code reports
      """

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
      description """
      This field is for code reports
      """

      constraints fields: [
                    raw_violations: [type: :string]
                  ]

      public? true
    end

    attribute :validation_details, :map do
      description """
      This field is for code reports
      """

      constraints fields: [
                    original_file_validation: [type: :string],
                    patched_file_validation: [type: :string],
                    original_tests_summary: [type: Hachiware.Reports.TestSummary],
                    patched_tests_summary: [type: Hachiware.Reports.TestSummary]
                  ]

      public? true
    end

    attribute :policy_details, :map do
      description """
      This field is for code reports
      """

      constraints fields: [
                    policy_file: [type: :string],
                    specific_rules: [type: {:array, :string}]
                  ]

      public? true
    end

    attribute :timing, :map do
      description """
      This field is for code reports
      """

      constraints fields: [
                    remediation_start_time: [type: :string],
                    remediation_end_time: [type: :string],
                    total_duration_seconds: [type: :float]
                  ]

      public? true
    end
  end
end
