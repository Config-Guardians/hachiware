defmodule Hachiware.Poller.Server do
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  def init(_init_arg) do
    IO.puts("Init done")

    timeout =
      Application.fetch_env!(:hachiware, Hachiware.Poller)
      |> Timex.Duration.from_clock()
      |> Timex.Duration.to_milliseconds(truncate: true)

    {:ok, timeout, timeout}
  end

  def handle_info(:timeout, timeout) do
    IO.puts("Starting task from Poller.Server")

    Hachiware.Provider.Steampipe.ActivePlugin
    |> Ash.read!()
    |> Stream.map(&Map.get(&1, :provider))
    |> Stream.map(&Module.concat(Hachiware.Provider, &1))
    |> Stream.map(&apply(&1, :watched_resources, []))
    |> Stream.flat_map(& &1)
    |> Enum.each(
      &Task.Supervisor.start_child(Hachiware.Poller, Hachiware.Poller.Runner, :run, [&1])
    )

    {:noreply, timeout, timeout}
  end
end
