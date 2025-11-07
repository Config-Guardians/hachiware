defmodule Hachiware.Provider.Github.RepositoryContent do
  use Ash.Resource,
    domain: Hachiware.Provider.Github,
    data_layer: AshPostgres.DataLayer,
    primary_read_warning?: false

  postgres do
    table "github_repository_content"
    schema "github"

    repo Hachiware.Provider.Steampipe.Repo
  end

  actions do
    read :read do
      argument :repository_full_name, :string do
        constraints match: ~r/^[a-zA-Z0-9-_]+\/[a-zA-Z0-9-._]+$/
        allow_nil? false
      end

      primary? true

      filter expr(repository_full_name == ^arg(:repository_full_name))
      filter expr(contains(path, ".properties") or contains(path, ".tf"))
    end
  end

  attributes do
    attribute :commit_url, :string do
      primary_key? true
      allow_nil? false
      select_by_default? false
    end

    for x <- [:path, :repository_full_name, :content] do
      attribute x, :string, public?: true
    end
  end
end

defimpl Hachiware.Poller.Runner.Diff, for: Hachiware.Provider.Github.RepositoryContent do
  def entry_id(%Hachiware.Provider.Github.RepositoryContent{
        repository_full_name: repo,
        path: path
      }),
      do: {repo, path}

  def diff_attribute(%Hachiware.Provider.Github.RepositoryContent{content: content}), do: content
end
