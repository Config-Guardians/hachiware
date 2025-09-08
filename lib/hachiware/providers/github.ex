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
  end

  domain do
    description "Resources related to AWS cloud provider"
  end
end
