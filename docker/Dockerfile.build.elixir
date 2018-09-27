FROM jessie_elixir173
# replaced by custom image using Jessie
# FROM elixir:1.7.3

MAINTAINER Areski <areski@gmail.com>

ENV REFRESHED_AT 2018-09-08

# Install hex
RUN /usr/local/bin/mix local.hex --force && \
    /usr/local/bin/mix local.rebar --force && \
    /usr/local/bin/mix hex.info

WORKDIR /app
COPY . .

RUN mix deps.get

CMD ["bash"]