defmodule Hachiware.Providers.Github do
  use Ash.Domain,
    extensions: [AshJsonApi.Domain]

  json_api do
    routes do
      base_route "/github/user", Hachiware.Providers.Github.User do
        get :read,
          name: "Github username",
          route: "/:login"
      end
    end
  end

  resources do
    resource Hachiware.Providers.Github.User

    resource Hachiware.Providers.Github.RepositoryContent do
      define :read_repo, args: [:repository_full_name], action: :read
    end
  end

  domain do
    description "Resources related to Github cloud provider"
  end
end
