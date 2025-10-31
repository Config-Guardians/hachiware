curr = %{id: 123_456, nest: %{type: :student}}
diff = %{id: 12345, nest: %{}}

Enum.each(diff, fn {k, v} ->
  prev = get_in(curr, [k])

  if prev != v do
    cond do
      is_list(v) ->
        IO.puts()

      is_map(v) ->
        curr = Map.get(curr, k)

        Enum.each(v, fn {k, v} ->
          prev = get_in(curr, [k])

          if prev != v do
            IO.puts("#{k} changed from #{prev} to #{v}")
          end
        end)

      true ->
        IO.puts("diff.#{k} changed from #{prev} to #{v}")
    end
  end
end)
