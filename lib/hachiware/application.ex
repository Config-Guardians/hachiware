defmodule Hachiware.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HachiwareWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:hachiware, :dns_cluster_query) || :ignore},
      Hachiware.Reports.Repo,
      Hachiware.Steampipe.Repo,
      {Phoenix.PubSub, name: Hachiware.PubSub},
      # Start a worker by calling: Hachiware.Worker.start_link(arg)
      # {Hachiware.Worker, arg},
      # Start to serve requests, typically the last entry
      HachiwareWeb.Endpoint,
      Hachiware.Poller.Server,
      {Task.Supervisor, name: Hachiware.Poller}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hachiware.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HachiwareWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
