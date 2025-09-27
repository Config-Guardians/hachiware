defmodule Hachiware.Provider.Aws.S3Bucket do
  use Ash.Resource,
    domain: Hachiware.Provider.Aws,
    data_layer: AshPostgres.DataLayer

  @behaviour Hachiware.Provider.WatchedResource
  def diff_attribute(%{acl: acl, policy: policy}), do: {acl, policy}

  def entry_id(%{arn: arn}), do: arn

  def module_name, do: "aws_s3"

  def retrieve_records do
    __MODULE__
    |> Ash.read!()
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
  end

  postgres do
    table "aws_s3_bucket"
    schema "aws"

    repo Hachiware.Provider.Steampipe.Repo
  end

  actions do
    defaults [:read]
  end
end
