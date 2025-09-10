defmodule Hachiware.Sse do
  use Ash.Domain,
    extensions: [AshJsonApi.Domain]

  json_api do
    routes do
      base_route "/sse" do
        route Hachiware.Sse.Connection, :get, "/connect", :broadcast
      end
    end
  end

  resources do
    resource Hachiware.Sse.Connection
  end
end
