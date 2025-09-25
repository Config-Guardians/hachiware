defmodule Hachiware.Provider.Aws.S3Bucket do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
  domain: Hachiware.Provider.Aws

  attributes do
    attribute :arn, :string do
      primary_key? true
      allow_nil? false
    end
  end

  postgres do
    table "aws_s3_bucket"
    schema "aws"

    repo Hachiware.Provider.Steampipe.Repo
  end
end
