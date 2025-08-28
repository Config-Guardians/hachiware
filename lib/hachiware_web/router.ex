defmodule HachiwareWeb.Router do
  use HachiwareWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HachiwareWeb do
    pipe_through :api
  end
end
