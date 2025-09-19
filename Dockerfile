FROM elixir:1.18.4-alpine
WORKDIR /app
ENV PHX_SERVER=true MIX_ENV=prod

COPY ./mix.* .
COPY ./config/config.exs ./config/
COPY ./config/prod.exs ./config/
RUN mix deps.get
RUN mix compile

COPY . .
RUN mix compile
ENTRYPOINT [ "sh", "-c", "export SECRET_KEY_BASE=$(mix phx.gen.secret); mix ash.setup; mix phx.server" ]
