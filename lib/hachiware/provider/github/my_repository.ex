defmodule Hachiware.Provider.Github.MyRepository do
  use Ash.Resource,
    domain: Hachiware.Provider.Github,
    data_layer: AshPostgres.DataLayer

  attributes do
    attribute :name_with_owner, :string do
      primary_key? true
      allow_nil? false
      public? true
    end
  end

  actions do
    defaults [:read]
  end

  postgres do
    table "github_my_repository"
    schema "github"

    repo Hachiware.Provider.Steampipe.Repo
  end

  @behaviour Hachiware.Provider.WatchedResource

  @impl Hachiware.Provider.WatchedResource
  def diff_attribute(struct), do: Hachiware.Provider.Github.RepositoryContent.diff_attribute(struct)

  @impl Hachiware.Provider.WatchedResource
  def entry_id(struct), do: Hachiware.Provider.Github.RepositoryContent.entry_id(struct)

  @impl Hachiware.Provider.WatchedResource
  def retrieve_records do
    __MODULE__
    |> Ash.read!()
    |> Stream.map(&Map.get(&1, :name_with_owner))
    |> Stream.flat_map(&(
      Hachiware.Provider.Github.RepositoryContent
      |> Ash.Query.for_read(:read, %{repository_full_name: &1})
      |> Ash.read!()
    ))
  end

  @impl Hachiware.Provider.WatchedResource
  def module_name, do: "github_files"
end
