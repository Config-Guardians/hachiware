defmodule Hachiware.Provider.WatchedResource do
  @callback retrieve_records :: Enumerable.t(struct())
  @callback module_name :: String.t()
  @callback entry_id(struct()) :: term()
  @callback diff_attribute(struct()) :: term()
end
