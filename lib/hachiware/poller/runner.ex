defmodule Hachiware.Poller.Runner do
  use Task

  def run(watched_resource) do
    watched_resource
    |> apply(:read_repo!, ["Zachareee/config-guardian-test"])
    |> Stream.map(fn x ->
      Stream.map(
        [:diff_attribute, :entry_id],
        &{&1, apply(Module.concat(watched_resource, :Selector), &1, [x])}
      )
      |> Map.new()
    end)
    |> Enum.each(&IO.inspect/1)

    # IO.puts("Runner.run called")
  end
end
