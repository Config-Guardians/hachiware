defmodule Hachiware.Provider.Aws do
  use Ash.Domain

  @resources [
    __MODULE__.S3Bucket,
    __MODULE__.VpcSecurityGroupRule,
    __MODULE__.VpcNetworkAcl,
    __MODULE__.IamPolicy,
    __MODULE__.IamAccountPasswordPolicy,
    __MODULE__.IamAccessKey
  ]

  @behaviour Hachiware.Provider

  @impl true
  def watched_resources, do: @resources

  resources do
    for x <- @resources do
      resource x
    end
  end

  domain do
    description "Resources related to AWS cloud provider"
  end
end
