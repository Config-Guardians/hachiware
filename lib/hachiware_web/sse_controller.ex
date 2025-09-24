defmodule HachiwareWeb.SseController do
  require Logger
  use HachiwareWeb, :controller

  def subscribe(conn, _) do
    SsePhoenixPubsub.stream(conn, {Hachiware.PubSub, ["diff"]})
  end
end
