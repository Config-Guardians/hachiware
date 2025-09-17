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
          {Hachiware.PubSub, "{\"parser\": \"hcl2\", \"content\": \"provider \\\"aws\\\" {\\n  region = \\\"ap-southeast-1\\\"\\n}\\nresource \\\"aws_ecr_repository\\\" \\\"scrooge_ecr\\\" {\\n  name                = \\\"scrooge-ecr\\\"\\n\\n  image_scanning_configuration {\\n    scan_on_push = true\\n  }\\n}\\n\"}"}
        )
      end
    end
  end
end
