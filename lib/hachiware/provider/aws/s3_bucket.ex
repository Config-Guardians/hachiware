defmodule Hachiware.Provider.Aws.S3Bucket do
  use Ash.Resource,
    domain: Hachiware.Provider.Aws,
    data_layer: AshPostgres.DataLayer

  @behaviour Hachiware.Provider.WatchedResource
  def diff_attribute(%{acl: acl, policy: policy}) do
    # Remove all instances of DisplayName (it returns nil sometimes and owner other times)
    pop_in(acl, ["Owner", "DisplayName"])
    |> elem(1)
    |> update_in(["Grants"], fn x ->
      Enum.map(x, &(pop_in(&1, ["Grantee", "DisplayName"]) |> elem(1)))
    end)
    |> then(&{&1, policy})
  end

  def entry_id(%{arn: arn}), do: arn

  def module_name, do: "aws_s3"

  def retrieve_records do
    __MODULE__
    |> Ash.read!()
  end

  postgres do
    table "aws_s3_bucket"
    schema "aws"

    repo Hachiware.Provider.Steampipe.Repo
  end

  actions do
    defaults [:read]
  end

  attributes do
    attribute :arn, :string do
      primary_key? true
      allow_nil? false
    end

    attribute :acl, :map do
      public? true
    end

    attribute :policy, :map do
      public? true
    end

    attribute :server_side_encryption_configuration, :map do
      constraints fields: [
                    Rules: [
                      type: {:array, :map},
                      constraints: [
                        fields: [
                          ApplyServerSideEncryptionByDefault: [
                            type: :map,
                            constraints: [
                              fields: [
                                KMSMasterKeyID: [type: :string],
                                SSEAlgorithm: [type: :string]
                              ]
                            ]
                          ],
                          BucketKeyEnabled: [type: :boolean]
                        ]
                      ]
                    ]
                  ]

      public? true
    end
  end
end
