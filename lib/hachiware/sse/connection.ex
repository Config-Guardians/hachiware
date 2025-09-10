defmodule Hachiware.Sse.Connection do
  use Ash.Resource,
    domain: Hachiware.Sse,
    extensions: [AshJsonApi.Resource]

  actions do
    action :broadcast do
      run fn _, _ ->
        Phoenix.PubSub.broadcast(
          Hachiware.PubSub,
          "Darling:HoldMyHand",
          {Hachiware.PubSub, "Nothing beats a Jet2 holiday"}
        )
      end
    end
  end
end
