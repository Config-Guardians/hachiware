defmodule Hachiware.Provider.WatchedResource do
  @callback retrieve_records :: Enumerable.t(struct())
  @callback module_name :: String.t()
end
