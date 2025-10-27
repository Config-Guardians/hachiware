defmodule Hachiware.Provider.Aws.VpcSecurityGroupRule do
  use Ash.Resource,
    domain: Hachiware.Provider.Aws,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "aws_vpc_security_group_rule"
    schema "aws"

    repo Hachiware.Provider.Steampipe.Repo
  end

  actions do
    defaults [:read]
  end

  attributes do
    attribute :security_group_rule_id, :string do
      primary_key? true
      public? true
      allow_nil? false
    end

    attribute :cidr_ipv4, :map do
      public? true
    end
  end

  @behaviour Hachiware.Provider.WatchedResource

  def diff_attribute(%{cidr_ipv4: ipv4}), do: ipv4

  def entry_id(%{security_group_rule_id: id}), do: id

  def module_name, do: "aws_vpc_security_group_rule"

  def retrieve_records do
    IO.puts("Scanning VPC SGs")

    __MODULE__
    |> Ash.read!()
  end
end

defimpl Jason.Encoder, for: Postgrex.INET do
  def encode(%Postgrex.INET{address: address, netmask: netmask}, opts) do
    Jason.Encode.map(%{address: Tuple.to_list(address), netmask: netmask}, opts)
  end
end
