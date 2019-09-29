FROM elixir:1.9-alpine

LABEL author="Giovanni Armane <giovanniarmane@gmail.com>"
LABEL license="MIT"

EXPOSE 4000

RUN apk add --no-cache --update nodejs npm inotify-tools

RUN adduser -u 1000 -D elixir && \
    mkdir -p /home/elixir/app

USER elixir

RUN mix local.hex --force && \
    mix archive.install hex phx_new --force

WORKDIR /home/elixir/app

CMD ["ash"]
