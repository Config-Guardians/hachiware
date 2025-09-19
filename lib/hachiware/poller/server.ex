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

    {:ok, {timeout, Hachiware.Provider.providers()}, timeout}
  end

  def handle_info(:timeout, {timeout, providers}) do
    IO.puts("Starting task from Poller.Server")

    providers
    |> Stream.map(&apply(&1, :watched_resources, []))
    |> Stream.flat_map(&(&1))
    |> Enum.each(
      &Task.Supervisor.start_child(Hachiware.Poller, Hachiware.Poller.Runner, :run, [&1])
    )

    {:noreply, {timeout, providers}, timeout}
  end
end
