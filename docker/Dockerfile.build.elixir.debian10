FROM elixir:1.10.0

MAINTAINER Areski <areski@gmail.com>

ENV REFRESHED_AT 2020-02-04

# Install hex
RUN /usr/local/bin/mix local.hex --force && \
    /usr/local/bin/mix local.rebar --force && \
    /usr/local/bin/mix hex.info

WORKDIR /app
COPY . .

RUN mix deps.get

CMD ["bash"]