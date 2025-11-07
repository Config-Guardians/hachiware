defmodule Hachiware.Provider.Aws.VpcSecurityGroupRule do
  use Hachiware.Provider.WatchedResource

  postgres do
    table "aws_vpc_security_group_rule"
    schema "aws"

    repo Hachiware.Provider.Steampipe.Repo
  end

  attributes do
    attribute :security_group_rule_id, :string do
      primary_key? true
      public? true
      allow_nil? false
    end

    for x <- [:cidr_ipv4, :cidr_ipv6] do
      attribute x, :map, public?: true
    end

    for x <- [:from_port, :to_port] do
      attribute x, :integer, public?: true
    end

    for x <- [:ip_protocol, :type] do
      attribute x, :string, public?: true
    end

    attribute :is_egress, :boolean, public?: true
  end

  @impl Hachiware.Provider.WatchedResource
  def module_name, do: "aws_vpc_security_group_rule"

  @impl Hachiware.Provider.WatchedResource
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

defimpl Hachiware.Poller.Runner.Diff, for: Hachiware.Provider.Aws.VpcSecurityGroupRule do
  def diff_attribute(map), do: map |> Map.from_struct() |> Map.delete(:security_group_rule_id)

  def entry_id(%Hachiware.Provider.Aws.VpcSecurityGroupRule{security_group_rule_id: id}), do: id
end
