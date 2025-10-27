defmodule Hachiware.Provider.Aws.VpcNetworkAcl do
  use Ash.Resource,
    domain: Hachiware.Provider.Aws,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "aws_vpc_network_acl"
    schema "aws"

    repo Hachiware.Provider.Steampipe.Repo
  end

  actions do
    defaults [:read]
  end

  attributes do
    attribute :arn, :string do
      primary_key? true
      public? true
      allow_nil? false
    end

    attribute :entries, {:array, :map} do
      public? true
    end
  end

  @behaviour Hachiware.Provider.WatchedResource

  def diff_attribute(%{entries: entries}), do: entries

  def entry_id(%{arn: arn}), do: arn

  def module_name, do: "aws_vpc_network_acl"

  def retrieve_records do
    IO.puts("Scanning VPC Network ACLs")

    __MODULE__
    |> Ash.read!()
  end
end
