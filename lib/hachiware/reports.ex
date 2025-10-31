defmodule Hachiware.Reports do
  use Ash.Domain,
    extensions: [AshJsonApi.Domain]

  json_api do
    routes do
      base_route "/code", Hachiware.Reports.Code do
        index :read

        get :read, route: "/:created_at"
        index :search, route: "/filter/:filter_value"

        post :create
      end

      base_route "/cloud", Hachiware.Reports.Cloud do
        index :read

        get :read, route: "/:created_at"
        index :search, route: "/filter/:filter_value"

        post :create
      end

      route Hachiware.Reports.Search, :get, "/search/:filter_value", :search
    end
  end

  resources do
    resource Hachiware.Reports.Code
    resource Hachiware.Reports.Cloud
    resource Hachiware.Reports.Search
  end
end
