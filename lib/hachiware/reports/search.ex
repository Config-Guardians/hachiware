defmodule Hachiware.Reports.Search do
  use Ash.Resource,
    domain: Hachiware.Reports,
    extensions: [AshJsonApi.Resource]

  actions do
    action :search, {:array, :map} do
      argument :filter_value, :string, allow_nil?: false
      run fn %Ash.ActionInput{arguments: arguments}, _ ->
        [Hachiware.Reports.Code, Hachiware.Reports.Cloud]
        |> Enum.flat_map(fn x -> 
          x
          |> Ash.Query.for_read(:search, Map.take(arguments, [:filter_value]))
          |> Ash.read!()
          |> Stream.map(&Map.from_struct/1)
          |> Stream.map(&Map.drop(&1, Hachiware.Provider.remove_ash_fields))
          |> Stream.map(&Map.put(
            &1,
            :resource_type,
            Module.split(x)
            |> List.last()
            |> String.downcase()
          ))
        end)
        |> then(&{:ok, &1})
      end
    end
  end

  json_api do
    type "search"
  end
end
