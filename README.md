# Collect Realtime information from FreeSWITCH to Influxdb & PostgreSQL [![Build Status](https://travis-ci.org/areski/freeswitch_realtime.svg?branch=master)](https://travis-ci.org/areski/freeswitch_realtime)


Collect Realtime information from [FreeSWITCH](https://freeswitch.org/) to [InfluxDB](https://influxdata.com/) & PostgreSQL.

Channels information are pushed in the form of:

  ```
  %ChannelSeries{fields: %ChannelSeries.Fields{value: 1},
  tags: %ChannelSeries.Tags{campaign_id: 1, host: "127.0.0.1"}, timestamp: nil}
  ```

If you wish to use this with an other project you might want to remove `campaign_id` which is specific to [Newfies-Dialer](https://www.newfies-dialer.org/).


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `freeswitch_realtime` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:freeswitch_realtime, "~> 0.1.0"}]
    end
    ```

  2. Ensure `freeswitch_realtime` is started before your application:

    ```elixir
    def application do
      [applications: [:freeswitch_realtime]]
    end
    ```

  3. Add host in your `/etc/hosts` eg:

    ```
    127.0.0.1     influxdb_host
    ```

  4. Create directory for logs:

    ```
    mkdir /var/log/freeswitch_realtime
    ```


## Compile & Build Release

  1. Edit version in `mix.exs`


  2. Compile:

      MIX_ENV=prod mix compile


  3. Build release:

      MIX_ENV=prod mix release


  4. Build Deb package:

      MIX_ENV=prod mix release --deb


## Start on reboot

  Add freeswitch_realtime to `systemd` on Debian 8.x:

  ```
  cp freeswitch_realtime.service /lib/systemd/system/freeswitch_realtime.service
  systemctl enable freeswitch_realtime.service
  systemctl daemon-reload
  systemctl restart freeswitch_realtime.service
  ```


## Todo

List of improvements and tasks,

- [ ] use [conform](https://github.com/bitwalker/conform) to support config file
- [ ] install script to quickly deploy
