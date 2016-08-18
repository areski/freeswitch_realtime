# FreeSWITCH channels Influxdb [![Build Status](https://travis-ci.org/areski/fs_channels_influxdb.svg?branch=master)](https://travis-ci.org/areski/fs_channels_influxdb)


Collect and push channels information from [FreeSWITCH](https://freeswitch.org/) Sqlite CoreDB to [InfluxDB](https://influxdata.com/).

Channels information are pushed in the form of:

  ```
  %ChannelSeries{fields: %ChannelSeries.Fields{value: 1},
  tags: %ChannelSeries.Tags{campaign_id: 1, host: "127.0.0.1",
   used_gateway_id: 2, user_id: 3}, timestamp: nil}
  ```

If you wish to use this with an other project you might want to remove `campaign_id`, `used_gateway_id` and `user_id` which are specific to [Newfies-Dialer](https://www.newfies-dialer.org/).


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

  3. Add host in your `/etc/hosts` eg:

    ```
    127.0.0.1     influxdb_host
    ```

  4. Create directory for logs:

    ```
    mkdir /var/log/fs_channels
    ```



## Todo

List of improvements and tasks,

- [ ] use [conform](https://github.com/bitwalker/conform) to support config file
- [ ] install script to quickly deploy
- [ ] push to PostgreSQL
- [ ] settings to remove
