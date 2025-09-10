defmodule HachiwareWeb.Router do
  use HachiwareWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/json" do
    pipe_through [:api]

    forward "/swaggerui", OpenApiSpex.Plug.SwaggerUI,
      path: "/api/json/open_api",
      default_model_expand_depth: 4

    forward "/", HachiwareWeb.AshJsonApiRouter
  end

  scope "/api", HachiwareWeb do
    pipe_through :api
  end

  pipeline :sse do
    plug :put_format, "text/event-stream"
    plug :fetch_session
  end

  scope "/sse", HachiwareWeb do
    pipe_through :sse

    get "/", SseController, :subscribe
  end
end
