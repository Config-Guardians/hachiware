# defmodule Hachiware.Sse.Connection do
#   use Ash.Resource,
#     domain: Hachiware.Sse,
#     extensions: [AshJsonApi.Resource]
#
#   actions do
#     action :broadcast, :tuple do
#       constraints fields: [
#                     at: [type: :atom],
#                     msg: [type: :term]
#                   ]
#
#       run Hachiware.Sse.ConnectionImplementation
#     end
#   end
# end
