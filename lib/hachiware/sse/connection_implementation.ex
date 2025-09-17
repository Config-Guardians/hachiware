defmodule Hachiware.Sse.ConnectionImplementation do
  use Ash.Resource.Actions.Implementation

  def run(_, _, _) do
    case Phoenix.PubSub.broadcast(
           Hachiware.PubSub,
           "Darling:HoldMyHand",
           {Hachiware.PubSub,
            "{\"parser\": \"hcl2\", \"content\": \"provider \\\"aws\\\" {\\n  region = \\\"ap-southeast-1\\\"\\n}\\nresource \\\"aws_ecr_repository\\\" \\\"scrooge_ecr\\\" {\\n  name                = \\\"scrooge-ecr\\\"\\n\\n  image_scanning_configuration {\\n    scan_on_push = true\\n  }\\n}\\n\"}"}
         ) do
      :ok ->
        {:ok, :ok}

      a ->
        a
    end
  end
end
