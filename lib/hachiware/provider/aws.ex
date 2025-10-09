defmodule Hachiware.Provider.Aws do
  use Ash.Domain

  @behaviour Hachiware.Provider

  @impl true
  def watched_resources, do: Enum.map([
    :S3Bucket
  ], &Module.concat(__MODULE__, &1))

  resources do
    resource __MODULE__.S3Bucket
  end

  domain do
    description "Resources related to AWS cloud provider"
  end
end
