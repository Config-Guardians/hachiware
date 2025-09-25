defmodule Hachiware.Provider.Aws do
  use Ash.Domain

  @behaviour Hachiware.Provider

  @impl true
  def watched_resources, do: []

  resources do
    resource __MODULE__.S3Bucket
  end

  domain do
    description "Resources related to AWS cloud provider"
  end
end
