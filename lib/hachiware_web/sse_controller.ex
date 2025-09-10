defmodule HachiwareWeb.SseController do
  require Logger
  use HachiwareWeb, :controller

  def subscribe(conn, _) do
    SsePhoenixPubsub.stream(conn, {Hachiware.PubSub, ["Darling:HoldMyHand"]})
    # case get_topics(params) do
    #   topics when is_list(topics) ->
    #     IO.inspect(params)
    #     SsePhoenixPubsub.stream(conn, {Hachiware.PubSub, topics})
    #
    #   _ ->
    #     Logger.error("No topics provided")
    # end
  end

  defp get_topics(params) do
    case params["topics"] do
      str when is_binary(str) -> String.split(str, ",")
      nil -> []
    end
  end
end
