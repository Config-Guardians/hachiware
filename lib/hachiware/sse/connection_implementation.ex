defmodule Hachiware.Sse.ConnectionImplementation do
  def send(message) do
    Phoenix.PubSub.broadcast(
      Hachiware.PubSub,
      "diff",
      {Hachiware.PubSub, Jason.encode!(message)}
    )
  end
end
