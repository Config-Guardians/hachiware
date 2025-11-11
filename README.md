<p align="center">
  <img width="75%" src="https://static.wikia.nocookie.net/chiikawa/images/6/61/SweetBabyHachiware2.png/revision/latest?cb=20240709065538" alt="Banner">
</p>

# Notes
Postgres must be installed as per [AshPostgres documentation](https://hexdocs.pm/ash_postgres/get-started-with-ash-postgres.html)
Make sure to run `mix ash.setup` before starting the server to setup the database
# Hachiware

## Funcionality
This repository combines the below into a single Phoenix/Ash server:

* A backend to store reports generated from our [agent system](https://github.com/Config-Guardians/agent-system) and view them within our [dashboard](https://github.com/Config-Guardians/dashboard)
* An extensible system to map resources available on [Steampipe](https://steampipe.io/) to a monitor-able target
  * As an example, here is how we mapped the [aws_iam_policy](https://hub.steampipe.io/plugins/turbot/aws/tables/aws_iam_policy) to [a target in Elixir](https://github.com/Config-Guardians/hachiware/blob/main/lib/hachiware/provider/aws/iam_policy.ex)
* A polling system to track changes made to these resources and push them to our [agent system](https://github.com/Config-Guardians/agent-system) through SSE if any are detected
  * Format of SSE messages can be found on [this GitHub gist](https://gist.github.com/Zachareee/fdb4dcc61ffed3081fe6ea9b7c039424)
* A pass-through REST API endpoint to configure credentials on our [steampipe-sidecar](https://github.com/Config-Guardians/steampipe-sidecar) component
  * The pass-through allows Hachiware to intercept successful credential parsing responses from steampipe-sidecar. The provider with the authenticated credentials will then have its resources monitored for changes

The pre-built Docker image is hosted at https://hub.docker.com/repository/docker/zachareee/hachiware

## Running the Server
To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Set the `SIDECAR_HOST`, `DATABASE_URL`, `STEAMPIPE_DATABASE_URL` environment variables
* * Refer to [Config Guardians](https://github.com/Config-Guardians/Config-Guardians/blob/1ebee47ca8479f9cc270c6114dae336063966827/docker-compose.yaml#L9) for an example on how to set it up with the required containers
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`SwaggerUI`](http://localhost:4000/api/swaggerui) from your browser to see the API documentation.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Running in Docker
Refer to [Config Guardians](https://github.com/Config-Guardians/Config-Guardians), which contains the whole system architecture we employ to power Config Guardians

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
