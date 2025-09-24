defmodule Hachiware.Poller.Storage do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec get_stored(atom()) :: map()
  def get_stored(atom) do
    Agent.get(__MODULE__, &Map.get(&1, atom, %{}))
  end

  @spec set_stored(atom(), map()) :: nil
  def set_stored(atom, map) do
    Agent.update(__MODULE__, &Map.put(&1, atom, map))
  end
end
