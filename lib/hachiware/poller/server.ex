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
      IO.inspect(module_name)

      if :ets.insert_new(__MODULE__, {module_name}) do
        IO.inspect("Created")

        Task.Supervisor.async_nolink(Hachiware.Poller, fn ->
          Module.concat(Hachiware.Provider, module_name)
          |> apply(:watched_resources, [])
          |> Enum.each(&Hachiware.Poller.Runner.run/1)

          module_name
        end)
      end
    end)
    |> Enum.to_list()

    {:noreply, timeout, timeout}
  end

  @impl GenServer
  def handle_info({_ref, module_name}, timeout) do
    IO.puts("Deleting")
    IO.inspect(module_name)

    :ets.delete(__MODULE__, module_name)
    {:noreply, timeout, timeout}
  end

  @impl GenServer
  def handle_info(_cat, timeout) do
    {:noreply, timeout, timeout}
  end
end
