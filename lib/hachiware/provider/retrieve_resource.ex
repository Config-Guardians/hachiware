defmodule Hachiware.Provider.RetrieveResource do
  @callback retrieve_records :: Enumerable.t(struct())
end
