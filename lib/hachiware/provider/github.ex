defmodule Hachiware.Provider.Github do
  use Ash.Domain,
    extensions: [AshJsonApi.Domain]

  @behaviour Hachiware.Provider

  json_api do
    routes do
      base_route "/github/user", Hachiware.Provider.Github.User do
        get :read,
          name: "Github username",
          route: "/:login"
      end
    end
  end

  resources do
    resource Hachiware.Provider.Github.User

    resource Hachiware.Provider.Github.RepositoryContent do
      define :read_repo, args: [:repository_full_name], action: :read
    end
  end

  domain do
    description "Resources related to Github cloud provider"
  end
end
