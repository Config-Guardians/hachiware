defmodule Hachiware.Provider.Github.MyRepository do
  use Hachiware.Provider.WatchedResource,
    domain: Hachiware.Provider.Github

  postgres do
    table "github_my_repository"
    schema "github"

    repo Hachiware.Provider.Steampipe.Repo
  end

  attributes do
    attribute :name_with_owner, :string do
      primary_key? true
      allow_nil? false
      public? true
    end

    attribute :login_id, :string, public?: true
  end

  @impl Hachiware.Provider.WatchedResource
  def module_name, do: "github_files"

  @impl Hachiware.Provider.WatchedResource
  def retrieve_records do
    IO.puts("Scanning Github repository content")

    __MODULE__
    |> Ash.read!()
    |> Stream.map(&Map.get(&1, :name_with_owner))
    |> Enum.map(
      &Task.async(fn ->
        Hachiware.Provider.Github.RepositoryContent
        |> Ash.Query.for_read(:read, %{repository_full_name: &1})
        |> Ash.read!()
      end)
    )
    |> Stream.map(&Task.await(&1, :infinity))
    |> Stream.flat_map(& &1)
  end
end
