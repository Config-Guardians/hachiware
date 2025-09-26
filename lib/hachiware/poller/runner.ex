defmodule Hachiware.Poller.Runner do
  use Task

  @spec run(atom()) :: []
  def run(watched_resource) do
    watched_resource
    |> apply(:retrieve_records, [])
    |> Stream.map(
      &{
        apply(watched_resource, :entry_id, [&1]),
        apply(watched_resource, :diff_attribute, [&1]),
        &1
      }
    )
    |> Stream.each(fn {id, diff, original} ->
      Hachiware.Poller.Storage.set_stored(fn stored_map ->
        entries = Map.get(stored_map, watched_resource, %{})

        if Map.get(entries, id) !== diff do
          Hachiware.Sse.ConnectionImplementation.send(%Hachiware.Sse.ConnectionImplementation{
            type: apply(watched_resource, :module_name, []),
            data:
              Map.drop(original, [
                :__lateral_join_source__,
                :__struct__,
                :__meta__,
                :__metadata__,
                :__order__,
                :aggregates,
                :calculations
              ])
          })
        end

        Map.put(entries, id, diff)
        |> then(&Map.put(stored_map, watched_resource, &1))
      end)
    end)
    |> Enum.to_list()
  end
end
