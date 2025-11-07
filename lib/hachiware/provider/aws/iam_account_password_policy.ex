defmodule Hachiware.Provider.Aws.IamAccountPasswordPolicy do
  use Hachiware.Provider.WatchedResource

  postgres do
    table "aws_iam_account_password_policy"
    schema "aws"

    repo Hachiware.Provider.Steampipe.Repo
  end

  attributes do
    attribute :account_id, :string do
      primary_key? true
      allow_nil? false
      public? true
    end

    for x <- [
          :expire_passwords,
          :require_lowercase_characters,
          :require_numbers,
          :require_symbols,
          :require_uppercase_characters
        ] do
      attribute(x, :boolean, public?: true)
    end

    for x <- [:max_password_age, :minimum_password_length] do
      attribute(x, :integer, public?: true)
    end
  end

  @impl Hachiware.Provider.WatchedResource
  def module_name, do: "aws_password_policy"

  @impl Hachiware.Provider.WatchedResource
  def retrieve_records do
    IO.puts("Scanning password policies")

    __MODULE__
    |> Ash.read!()
  end
end

defimpl Hachiware.Poller.Runner.Diff, for: Hachiware.Provider.Aws.IamAccountPasswordPolicy do
  def entry_id(%Hachiware.Provider.Aws.IamAccountPasswordPolicy{account_id: account_id}),
    do: account_id

  def diff_attribute(%Hachiware.Provider.Aws.IamAccountPasswordPolicy{} = s),
    do: Map.from_struct(s) |> Map.delete(:account_id)
end
