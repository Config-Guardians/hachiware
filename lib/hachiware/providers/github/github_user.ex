defmodule Hachiware.Providers.Github.GithubUser do
  use Ash.Resource,
    domain: Hachiware.Providers.Github,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  attributes do
    attribute :login, :string do
      primary_key? true
      public? true
      allow_nil? false
    end

    attribute :name, :string do
      public? true
      allow_nil? false
    end

    attribute :id, :integer do
      public? true
    end

    attribute :followers_total_count, :integer do
      public? true
    end

    attribute :location, :string do
      public? true
    end
    
    attribute :url, :string do
      public? true
    end
  end

  actions do
    defaults [:read]
  end

  json_api do
    type "user"

    routes do
      base "/github/user"

      get :read, name: "Github username", route: "/:login"
    end
  end

  postgres do
    table "github_user"
    schema "github"

    repo Hachiware.Repo
  end
end
