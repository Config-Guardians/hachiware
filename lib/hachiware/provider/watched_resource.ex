defmodule Hachiware.Provider.WatchedResource do
  @callback entry_id(struct()) :: term()
  @callback diff_attribute(struct()) :: term()
end
