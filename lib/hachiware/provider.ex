defmodule Hachiware.Provider do
  @callback watched_resources() :: Enumerable.t(atom())
end
