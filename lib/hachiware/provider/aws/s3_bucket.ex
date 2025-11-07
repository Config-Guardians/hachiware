defmodule Hachiware.Provider.Aws.S3Bucket do
  use Hachiware.Provider.WatchedResource

  @impl Hachiware.Provider.WatchedResource
  def module_name, do: "aws_s3"

  @impl Hachiware.Provider.WatchedResource
  def retrieve_records do
    IO.puts("Scanning S3 buckets")

    __MODULE__
    |> Ash.read!()
  end

  postgres do
    table "aws_s3_bucket"
    schema "aws"

    repo Hachiware.Provider.Steampipe.Repo
  end

  attributes do
    attribute :arn, :string do
      primary_key? true
      allow_nil? false
    end

    attribute :acl, :map, public?: true

    attribute :policy, :map, public?: true

    attribute :versioning_enabled, :boolean, public?: true

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

defimpl Hachiware.Poller.Runner.Diff, for: Hachiware.Provider.Aws.S3Bucket do
  def entry_id(%Hachiware.Provider.Aws.S3Bucket{arn: arn}), do: arn

  def diff_attribute(%Hachiware.Provider.Aws.S3Bucket{
        acl: acl,
        policy: policy,
        versioning_enabled: ver,
        server_side_encryption_configuration: sse
      }) do
    # Remove all instances of DisplayName (it returns nil sometimes and owner other times)
    pop_in(acl, ["Owner", "DisplayName"])
    |> elem(1)
    |> update_in(["Grants"], fn x ->
      Enum.map(x, &(pop_in(&1, ["Grantee", "DisplayName"]) |> elem(1)))
    end)
    |> then(&{&1, policy, ver, sse})
  end
end
