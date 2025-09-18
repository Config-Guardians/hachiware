defmodule Hachiware.Poller.Server do
  use GenServer

  @timeout Application.compile_env(:hachiware, Hachiware.Poller)
           |> Timex.Duration.from_clock()
           |> Timex.Duration.to_milliseconds(truncate: true)

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  def init(_init_arg) do
    IO.puts("Init done")
    {:ok, nil, @timeout}
  end

  def handle_info(:timeout, _) do
    IO.puts("Starting task from Poller.Server")
    Task.Supervisor.start_child(Hachiware.Poller, Hachiware.Poller.Runner, :run, [])
    {:noreply, nil, @timeout}
  end
end
