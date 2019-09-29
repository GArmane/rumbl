FROM elixir:1.9-alpine

LABEL author="Giovanni Armane <giovanniarmane@gmail.com>"
LABEL license="MIT"

EXPOSE 4000

RUN apk add --no-cache --update nodejs npm inotify-tools

ENV PATH=./node_modules/.bin:$PATH

RUN adduser -u 1000 -D elixir && \
    mkdir -p /home/elixir/app

USER elixir

ONBUILD RUN mix do local.hex --force, local.rebar --force, archive.install hex phx_new --force

WORKDIR /home/elixir/app

CMD ["ash"]
