defmodule Hachiware.Provider.Aws.VpcNetworkAcl do
  use Hachiware.Provider.WatchedResource

  postgres do
    table "aws_vpc_network_acl"
    schema "aws"

    repo Hachiware.Provider.Steampipe.Repo
  end

  attributes do
    attribute :arn, :string do
      primary_key? true
      public? true
      allow_nil? false
    end

    attribute :entries, {:array, :map}, public?: true
  end

  @impl Hachiware.Provider.WatchedResource
  def module_name, do: "aws_vpc_network_acl"

  @impl Hachiware.Provider.WatchedResource
  def retrieve_records do
    IO.puts("Scanning VPC Network ACLs")

    __MODULE__
    |> Ash.read!()
  end
end

defimpl Hachiware.Poller.Runner.Diff, for: Hachiware.Provider.Aws.VpcNetworkAcl do
  def diff_attribute(%Hachiware.Provider.Aws.VpcNetworkAcl{entries: entries}), do: entries

  def entry_id(%Hachiware.Provider.Aws.VpcNetworkAcl{arn: arn}), do: arn
end
