defmodule Hachiware.Provider do
  @callback watched_resources() :: Enumerable.t(atom())

  def remove_ash_fields,
    do: [
      :__lateral_join_source__,
      :__struct__,
      :__meta__,
      :__metadata__,
      :__order__,
      :aggregates,
      :calculations
    ]
end
