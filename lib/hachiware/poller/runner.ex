defmodule Hachiware.Poller.Runner do
  use Task

  @spec run(atom()) :: []
  def run(watched_resource) do
    watched_resource
    |> apply(:retrieve_records, [])
    |> Stream.map(
      &{
        __MODULE__.Diff.entry_id(&1),
        __MODULE__.Diff.diff_attribute(&1),
        &1
      }
    )
    |> Stream.each(&diff_on_record(watched_resource, &1))
    |> Stream.run()
  end

  defp diff_on_record(watched_resource, {id, diff, original}) do
    Task.Supervisor.start_child(Hachiware.Poller, fn ->
      Hachiware.Poller.Storage.set_stored(fn stored_map ->
        entries = Map.get(stored_map, watched_resource, %{})

        if Map.get(entries, id) !== diff do
          Hachiware.Sse.ConnectionImplementation.send(%Hachiware.Sse.ConnectionImplementation{
            type: apply(watched_resource, :module_name, []),
            data: Map.drop(original, Hachiware.Provider.remove_ash_fields())
          })
        end

        Map.put(entries, id, diff)
        |> then(&Map.put(stored_map, watched_resource, &1))
      end)
    end)
  end
end
