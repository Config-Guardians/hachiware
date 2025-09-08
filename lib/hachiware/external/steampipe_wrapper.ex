defmodule Hachiware.External.SteampipeWrapper do
  use Ash.Resource.Actions.Implementation

  def run(%Ash.ActionInput{arguments: args}, _opts, _ctx) do
    %Req.Response{body: json} =
      (Application.fetch_env!(:hachiware, Hachiware.External.SteampipeWrapper) <> "/plugin")
      |> Req.post!(json: args)

    {:ok, json}
  end
end
