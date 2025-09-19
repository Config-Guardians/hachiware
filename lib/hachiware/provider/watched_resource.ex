defmodule Hachiware.Provider.WatchedResource do
  @callback entry_id(struct :: %{__struct__: atom}) :: term()
  @callback diff_attribute(struct :: %{__struct__: atom}) :: term()
end
