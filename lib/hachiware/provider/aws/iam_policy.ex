defmodule Hachiware.Provider.Aws.IamPolicy do
  use Ash.Resource,
    domain: Hachiware.Provider.Aws,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "aws_iam_policy"
    schema "aws"

    repo Hachiware.Provider.Steampipe.Repo
  end

  actions do
    read :read do
      primary? true

      filter expr(is_aws_managed == false)
    end
  end

  attributes do
    attribute :arn, :string do
      primary_key? true
      public? true
      allow_nil? false
    end

    attribute :policy, :map do
      public? true
    end

    attribute :policy_std, :map do
      public? true
    end

    attribute :is_aws_managed, :boolean do
      public? true
    end
  end

  @behaviour Hachiware.Provider.WatchedResource

  @impl Hachiware.Provider.WatchedResource
  def module_name, do: "aws_iam_policy"

  @impl Hachiware.Provider.WatchedResource
  def retrieve_records do
    IO.puts("Scanning IAM policies")

    __MODULE__
    |> Ash.read!()
  end
end

defimpl Hachiware.Poller.Runner.Diff, for: Hachiware.Provider.Aws.IamPolicy do
  def diff_attribute(%Hachiware.Provider.Aws.IamPolicy{policy_std: data}), do: data

  def entry_id(%Hachiware.Provider.Aws.IamPolicy{arn: arn}), do: arn
end
