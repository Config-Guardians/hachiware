defmodule Hachiware.Poller.Runner do
  use Task

  @spec run(atom()) :: nil
  def run(watched_resource) do
    current_map =
      watched_resource
      |> apply(:retrieve_records, [])
      |> Stream.map(
        &{
          apply(watched_resource, :entry_id, [&1]),
          {apply(watched_resource, :diff_attribute, [&1]), &1}
        }
      )
      |> Map.new()

    stored_map = Hachiware.Poller.Storage.get_stored(watched_resource)

    diff =
      Map.reject(current_map, fn {k, {v, _}} ->
        Map.has_key?(stored_map, k) && Map.get(stored_map, k) == v
      end)

    if diff !== %{} do
      merged =
        Map.merge(
          stored_map,
          diff
          |> Stream.map(fn {k, {v, _}} -> {k, v} end)
          |> Map.new()
        )

      Hachiware.Sse.ConnectionImplementation.send(%Hachiware.Sse.ConnectionImplementation{
        type: apply(watched_resource, :module_name, []),
        data:
          Enum.map(diff, fn {_, {_, m}} ->
            Map.drop(m, [:__struct__, :__meta__])
          end)
      })

      Hachiware.Poller.Storage.set_stored(watched_resource, merged)
    end
  end
end
