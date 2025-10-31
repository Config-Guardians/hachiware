defmodule Hachiware.Reports.Search do
  use Ash.Resource,
    domain: Hachiware.Reports,
    extensions: [AshJsonApi.Resource]

  actions do
    action :search, {:array, :map} do
      argument :filter_value, :string, allow_nil?: false
      run fn input, _ ->
        searchkey = input.arguments.filter_value
        [Hachiware.Reports.Code, Hachiware.Reports.Cloud]
        |> Enum.flat_map(fn x -> 
          x
          |> Ash.Query.for_read(:search, %{filter_value: searchkey})
          |> Ash.read!()
        end)
        |> then(&{:ok, &1})
      end
    end
  end

  json_api do
    type "search"
  end
end
