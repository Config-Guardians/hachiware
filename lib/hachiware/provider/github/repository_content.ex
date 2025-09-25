defmodule Hachiware.Provider.Github.RepositoryContent do
  use Ash.Resource,
    domain: Hachiware.Provider.Github,
    data_layer: AshPostgres.DataLayer,
  primary_read_warning?: false

  attributes do
    attribute :commit_url, :string do
      primary_key? true
      allow_nil? false
      select_by_default? false
    end

    attribute :path, :string do
      public? true
      description "The path of the file."
    end

    attribute :repository_full_name, :string do
      public? true
      description "The full name of the repository (login/repo-name)."
    end

    attribute :content, :string do
      public? true
      description "The decoded file content (if the element is a file)."
    end
  end

  actions do
    read :read do
      argument :repository_full_name, :string do
        constraints match: ~r/^[a-zA-Z0-9-]+\/[a-zA-Z0-9-.]+$/
        allow_nil? false
      end
      primary? true

      filter expr(repository_full_name == ^arg(:repository_full_name))
      filter expr(contains(path, "application.properties"))
      #filter(expr do
      #  __MODULE__.Macro.contains_list(["application.properties"], path, :contains)
      #end)
    end
  end

  postgres do
    table "github_repository_content"
    schema "github"

    repo Hachiware.Provider.Steampipe.Repo
  end

  def diff_attribute(%{content: content}), do: content
  def entry_id(%{repository_full_name: repo, path: path}), do: {repo, path}
end
