# FreeSWITCH channels Influxdb [![Build Status](https://travis-ci.org/areski/fs_channels_influxdb.svg?branch=master)](https://travis-ci.org/areski/fs_channels_influxdb)


Collect and push channels information from FreeSWITCH Sqlite to InfluxDB

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `fs_channels` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:fs_channels, "~> 0.1.0"}]
    end
    ```

  2. Ensure `fs_channels` is started before your application:

    ```elixir
    def application do
      [applications: [:fs_channels]]
    end
    ```

**TODO: Add description**
