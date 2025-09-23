defmodule Hachiware.Provider.Steampipe.SteampipeWrapper do
  use Ash.Resource.Actions.Implementation

  def run(%Ash.ActionInput{arguments: args}, _opts, _ctx) do
    %Req.Response{body: json} =
      ("http://" <>
         Application.fetch_env!(:hachiware, Hachiware.Provider.Steampipe.SteampipeWrapper) <>
         "/plugin")
      |> Req.post!(json: args, receive_timeout: :infinity)

    {:ok, json}
  end
end
