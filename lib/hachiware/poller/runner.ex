defmodule Hachiware.Poller.Runner do
  use Task

  @spec run(atom()) :: nil
  def run(watched_resource) do
    # watched_resource.retrieve_records.()
    current_map =
      watched_resource
      |> apply(:retrieve_records, [])
      |> Stream.map(
        &{
          # watched_resource.entry_id.(&1)
          apply(watched_resource, :entry_id, [&1]),
          {apply(watched_resource, :diff_attribute, [&1]), &1}
          # {watched_resource.diff_attribute.(&1), &1}
        }
      )
      |> Map.new()

    stored_map = Hachiware.Poller.Storage.get_stored(watched_resource)

    diff =
      Map.reject(current_map, fn {k, v} ->
        Map.has_key?(stored_map, k) && Map.get(stored_map, k) == v
      end)

    if diff !== %{} do
      merged =
        Map.merge(stored_map, diff, fn _, _, v ->
          v
        end)

      Hachiware.Poller.Storage.set_stored(watched_resource, merged)

      Hachiware.Sse.ConnectionImplementation.send(diff)
    end

    # IO.puts("Runner.run called")
  end
end
