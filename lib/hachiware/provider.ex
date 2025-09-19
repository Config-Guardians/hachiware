defmodule Hachiware.Provider do
  @callback watched_resources() :: Enumerable.t(atom())

  def providers, do: [Hachiware.Provider.Github]
end
