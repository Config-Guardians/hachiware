defmodule Hachiware.Provider.Aws do
  use Ash.Domain

  @behaviour Hachiware.Provider

  @impl true
  def watched_resources,
    do:
      Enum.map(
        [
          :S3Bucket,
          :VpcSecurityGroupRule,
          :VpcNetworkAcl
        ],
        &Module.concat(__MODULE__, &1)
      )

  resources do
    resource __MODULE__.S3Bucket
    resource __MODULE__.VpcSecurityGroupRule
    resource __MODULE__.VpcNetworkAcl
  end

  domain do
    description "Resources related to AWS cloud provider"
  end
end
