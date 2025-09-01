defmodule Hachiware.Providers.Github do
  use Ash.Domain,
    extensions: [AshJsonApi.Domain]

  resources do
    resource Hachiware.Providers.Github.GithubUser
  end

  domain do
    description "Resources related to AWS cloud provider"
  end
end
