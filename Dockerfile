FROM elixir:1.18.4-alpine
WORKDIR /app
ENV PHX_SERVER=true MIX_ENV=prod

COPY ./mix.* .
RUN mix deps.get

COPY . .
RUN mix compile
ENTRYPOINT [ "sh", "-c", "export SECRET_KEY_BASE=$(mix phx.gen.secret); mix ash.setup; mix phx.server" ]
