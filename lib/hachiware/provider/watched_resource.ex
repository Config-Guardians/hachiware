defmodule Hachiware.Provider.WatchedResource do
  defmacro __using__(opts) do
    new_opts = Keyword.merge([data_layer: AshPostgres.DataLayer, domain: Hachiware.Provider.Aws], opts)

    quote do
      use Ash.Resource, unquote(new_opts)

      @behaviour Hachiware.Provider.WatchedResource

      actions do
        defaults [:read]
      end
    end
  end

  @callback retrieve_records :: Enumerable.t(struct())
  @callback module_name :: String.t()
end
