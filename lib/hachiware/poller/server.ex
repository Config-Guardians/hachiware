defmodule Hachiware.Poller.Server do
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  @impl GenServer
  def init(_init_arg) do
    :ets.new(__MODULE__, [:named_table, :private, write_concurrency: true])

    timeout =
      Application.fetch_env!(:hachiware, Hachiware.Poller)
      |> Timex.Duration.from_clock()
      |> Timex.Duration.to_milliseconds(truncate: true)

    {:ok, timeout, timeout}
  end

  @impl GenServer
  def handle_info(:timeout, timeout) do
    IO.puts("Starting task from Poller.Server")

    Hachiware.Provider.Steampipe.ActivePlugin
    |> Ash.read!()
    |> Stream.map(&Map.get(&1, :provider))
    |> Stream.map(fn module_name ->
      if not :ets.member(__MODULE__, module_name) do
        :ets.insert(
          __MODULE__,
          {module_name,
           Task.Supervisor.async_nolink(
             Hachiware.Poller,
             fn ->
               Module.concat(Hachiware.Provider, module_name)
               |> apply(:watched_resources, [])
               |> Enum.each(&Hachiware.Poller.Runner.run/1)
             end
           ).pid}
        )
      end
    end)
    |> Stream.run()

    {:noreply, timeout, timeout}
  end

  @impl GenServer
  def handle_info({:DOWN, _ref, :process, pid, _trace}, timeout) do
    :ets.match_delete(__MODULE__, {:_, pid})
    {:noreply, timeout, timeout}
  end

  @impl GenServer
  def handle_info(_cat, timeout) do
    {:noreply, timeout, timeout}
  end
end
