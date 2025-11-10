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
    |> then(
      &Task.Supervisor.async_stream_nolink(
        Hachiware.Poller,
        &1,
        fn x ->
          Hachiware.Provider.Github.RepositoryContent
          |> Ash.Query.for_read(:read, %{repository_full_name: x})
          |> Ash.read!()
        end,
        timeout: :infinity
      )
    )
    |> Stream.filter(&match?({:ok, _}, &1))
    |> Stream.map(&elem(&1, 1))
    |> Stream.flat_map(& &1)
  end
end
