# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :fs_realtime, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:fs_realtime, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

# tell logger to load a LoggerFileBackend processes
config :logger,
  backends: [{LoggerFileBackend, :error_log}, {LoggerFileBackend, :debug_log}]

# configuration for the {LoggerFileBackend, :error_log} backend
config :logger, :error_log,
  path: "/tmp/error.log",
  level: :warn,
  format: "$date $time $metadata[$level] $levelpad$message\n"

# metadata: [:file, :line]

# configuration for the {LoggerFileBackend, :debug_log} backend
config :logger, :debug_log,
  path: "/tmp/debug.log",
  level: :info,
  format: "$date $time $metadata[$level] $levelpad$message\n"

# metadata: [:file, :line]

# config :logger,
#   backends: [:console],
#   compile_time_purge_level: :debug

# config :logger, :console,
#   format: "\n$time $metadata[$level] $levelpad$message\n"

config :fs_realtime,
  sqlite_db: "/dev/shm/core.db",
  influxdatabase: "newfiesdialer",
  local_host: "LOCAL_IP",
  heartbeat: 2000

config :fs_realtime, ecto_repos: [FSRealtime.Repo]

# DB access
config :fs_realtime, FSRealtime.Repo,
  url: "postgres://postgres:password@localhost/newfiesdb",
  pool_size: 10,
  pool: Ecto.Adapters.SQL.Sandbox

# Push to InfluxDB
config :fs_realtime, FSRealtime.InConnection,
  host: "localhost",
  # http_opts: [ insecure: true, proxy: "http://company.proxy" ],
  pool: [max_overflow: 0, size: 1],
  port: 8086,
  scheme: "http",
  writer: Instream.Writer.Line
