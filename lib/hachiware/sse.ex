# defmodule Hachiware.Sse do
#   use Ash.Domain,
#     extensions: [AshJsonApi.Domain]
#
#   json_api do
#     routes do
#       base_route "/sse" do
#         route Hachiware.Sse.Connection, :get, "/connect", :broadcast do
#           name "Ping SSE connection"
#
#           description "Sending a request to this path will send an SSE message from the server to any connected clients"
#         end
#       end
#     end
#   end
#
#   resources do
#     resource Hachiware.Sse.Connection
#   end
# end
