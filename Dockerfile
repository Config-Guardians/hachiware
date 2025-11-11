FROM elixir:1.19.0-alpine
WORKDIR /app
RUN ["sh", "-c", "apk add curl"]
ENV PHX_SERVER=true
#MIX_ENV=prod

COPY ./mix.* .
COPY ./config/config.exs ./config/
COPY ./config/dev.exs ./config/
COPY ./config/prod.exs ./config/

RUN ["sh", "-c", "mix setup"]
RUN ["sh", "-c", "mix compile"]

COPY . .
RUN ["sh", "-c", "mix compile"]
ENTRYPOINT [ "sh", "-c", "export SECRET_KEY_BASE=$(mix phx.gen.secret); mix ash.migrate -r Hachiware.Reports.Repo; mix phx.server" ]
