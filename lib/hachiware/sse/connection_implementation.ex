defmodule Hachiware.Sse.ConnectionImplementation do
  defstruct [:type, :data]

  @type t :: %__MODULE__{type: String.t(), data: Enumerable.t(struct())}

  @spec send(%__MODULE__{}) :: term()
  def send(message) do
    Phoenix.PubSub.broadcast(
      Hachiware.PubSub,
      "diff",
      {Hachiware.PubSub, Jason.encode!(message)}
    )
  end
end
