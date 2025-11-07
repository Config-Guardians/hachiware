defmodule Hachiware.Provider.Aws.IamAccessKey do
  use Hachiware.Provider.WatchedResource

  postgres do
    table "aws_iam_access_key"
    schema "aws"

    repo Hachiware.Provider.Steampipe.Repo
  end

  attributes do
    attribute :access_key_id, :string do
      public? true
      primary_key? true
      allow_nil? false
    end

    attribute :access_key_last_used_date, :datetime, public?: true

    for x <- [
          :access_key_last_used_region,
          :access_key_last_used_service,
          :account_id,
          :status,
          :user_name
        ] do
      attribute x, :string, public?: true
    end
  end

  @impl Hachiware.Provider.WatchedResource
  def module_name, do: "aws_iam_access_key"

  @impl Hachiware.Provider.WatchedResource
  def retrieve_records do
    IO.puts("Scanning access keys")

    __MODULE__
    |> Ash.read!()
  end
end

defimpl Hachiware.Poller.Runner.Diff, for: Hachiware.Provider.Aws.IamAccessKey do
  def entry_id(%Hachiware.Provider.Aws.IamAccessKey{access_key_id: access_key_id}),
    do: access_key_id

  def diff_attribute(%Hachiware.Provider.Aws.IamAccessKey{} = s),
    do: Map.from_struct(s) |> Map.delete(:access_key_id)
end
