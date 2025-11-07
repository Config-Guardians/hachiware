defmodule Hachiware.Provider.Github do
  use Ash.Domain

  @behaviour Hachiware.Provider

  @impl true
  def watched_resources, do: __MODULE__.MyRepository

  resources do
    resource __MODULE__.RepositoryContent
    resource __MODULE__.MyRepository
  end

  domain do
    description "Resources related to Github cloud provider"
  end
end
