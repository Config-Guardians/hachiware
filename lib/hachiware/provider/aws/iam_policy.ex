defmodule Hachiware.Provider.Aws.IamPolicy do
  use Hachiware.Provider.WatchedResource

  postgres do
    table "aws_iam_policy"
    schema "aws"

    repo Hachiware.Provider.Steampipe.Repo
  end

  attributes do
    attribute :arn, :string do
      primary_key? true
      public? true
      allow_nil? false
    end

    attribute :policy_std, :map, public?: true

    attribute :is_aws_managed, :boolean, public?: true
  end

  @impl Hachiware.Provider.WatchedResource
  def module_name, do: "aws_iam_policy"

  @impl Hachiware.Provider.WatchedResource
  def retrieve_records do
    IO.puts("Scanning IAM policies")

    require Ash.Query

    __MODULE__
    |> Ash.Query.filter(not is_aws_managed)
    |> Ash.read!()
  end
end

defimpl Hachiware.Poller.Runner.Diff, for: Hachiware.Provider.Aws.IamPolicy do
  def diff_attribute(%Hachiware.Provider.Aws.IamPolicy{policy_std: data}), do: data

  def entry_id(%Hachiware.Provider.Aws.IamPolicy{arn: arn}), do: arn
end
