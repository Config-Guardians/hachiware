defmodule Hachiware.Poller.Storage do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec set_stored((map() -> map())) :: nil
  def set_stored(f) do
    Agent.update(__MODULE__, f)
  end
end
