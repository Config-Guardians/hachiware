defmodule Hachiware.Provider.Github do
  use Ash.Domain,
    extensions: [AshJsonApi.Domain]

  @behaviour Hachiware.Provider

  @impl true
  def watched_resources, do: [Hachiware.Provider.Github.MyRepository]

  resources do
    resource __MODULE__.RepositoryContent
    resource __MODULE__.MyRepository
  end

  domain do
    description "Resources related to Github cloud provider"
  end
end
