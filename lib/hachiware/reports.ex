defmodule Hachiware.Reports do
  use Ash.Domain,
    extensions: [AshJsonApi.Domain]

  json_api do
    routes do
      base_route "/report", Hachiware.Reports.Report do
        index :read

        get :read, route: "/:created_at"

        post :create
      end
    end
  end

  resources do
    resource Hachiware.Reports.Report
  end
end
