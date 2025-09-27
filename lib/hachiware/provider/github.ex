defmodule Hachiware.Provider.Github do
  use Ash.Domain,
    extensions: [AshJsonApi.Domain]

  @behaviour Hachiware.Provider

  @impl true
  def watched_resources,
    do:
      Enum.map(
        [
          :MyRepository
        ],
        &Module.concat(__MODULE__, &1)
      )

  resources do
    resource __MODULE__.RepositoryContent
    resource __MODULE__.MyRepository
  end

  domain do
    description "Resources related to Github cloud provider"
  end
end
