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
#     config :freeswitch_realtime, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:freeswitch_realtime, :key)
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
  backends: [{LoggerFileBackend, :error_log},
             {LoggerFileBackend, :debug_log}]

# configuration for the {LoggerFileBackend, :error_log} backend
config :logger, :error_log,
  path: "/var/log/freeswitch_realtime/elixir-error.log",
  level: :error,
  format: "$time $metadata[$level] $levelpad$message\n"
  # metadata: [:file, :line]

# configuration for the {LoggerFileBackend, :debug_log} backend
config :logger, :debug_log,
  path: "/var/log/freeswitch_realtime/elixir-debug.log",
  level: :debug,
  format: "$time $metadata[$level] $levelpad$message\n"
  # metadata: [:file, :line]


# config :logger,
#   backends: [:console],
#   compile_time_purge_level: :debug

# config :logger, :console,
#   format: "\n$time $metadata[$level] $levelpad$message\n"

config :freeswitch_realtime,
  sqlite_db: "/dev/shm/core.db",
  # influxdatabase:  "newfiesdialer",
  influxdatabase:  "newfiesdialer"

# InfluxDB configuration
config :freeswitch_realtime, FreeswitchRealtime.InConnection,
  host:      "localhost",
  # http_opts: [ insecure: true, proxy: "http://company.proxy" ],
  pool:      [ max_overflow: 0, size: 1 ],
  port:      8086,
  scheme:    "http",
  writer:    Instream.Writer.Line


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
