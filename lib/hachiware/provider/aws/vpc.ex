defmodule Hachiware.Provider.Aws.Vpc do
  use Ash.Resource,
    domain: Hachiware.Provider.Aws,
    data_layer: AshPostgres.DataLayer

  @behaviour Hachiware.Provider.WatchedResource

  attributes do
    attribute :arn, :string do
      primary_key? true
      allow_nil? false
    end
  end

  postgres do
    table "aws_vpc"
    schema "aws"

    repo Hachiware.Provider.Steampipe.Repo
  end

  actions do
    defaults [:read]
  end
end
