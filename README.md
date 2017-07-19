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

3. Create directory for logs:

    ```
    mkdir /var/log/freeswitch_realtime
    ```

4. Add host in your `/etc/hosts` eg:

    ```
    127.0.0.1     influxdb_host
    ```

# Compile & Build Release

1. Edit version in `mix.exs`


2. Compile:

    MIX_ENV=prod mix compile


3. Build release:

    MIX_ENV=prod mix release


## Start on reboot

Add freeswitch_realtime to `systemd` on Debian 8.x:

    cp freeswitch_realtime.service /lib/systemd/system/freeswitch_realtime.service
    systemctl enable freeswitch_realtime.service
    systemctl daemon-reload
    systemctl restart freeswitch_realtime.service


## Troubleshoot

Ensure InfluxDB is working properly.

Create DB::

    curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE mydb"


Write to serie cpu_load_short::

    curl -i -XPOST 'http://localhost:8086/write?db=mydb' --data-binary 'cpu_load_short,host=server01,region=us-west value=0.64 1434055562000000000'


Read data::

    curl -G 'http://localhost:8086/query?pretty=true' --data-urlencode "db=mydb" --data-urlencode "q=SELECT \"value\" FROM \"cpu_load_short\" WHERE \"region\"='us-west'"


With to database `newfiesdialer` serie `freeswitch_channels_cpg_total`::

    curl -i -XPOST 'http://localhost:8086/write?db=newfiesdialer' --data-binary 'freeswitch_channels_cpg_total,host=37.139.13.157,campaign_id=1,leg_type=1 value=0.64 1434055562000000000'

Read from serie `freeswitch_channels_cpg_total`:

    curl -G 'http://localhost:8086/query?pretty=true' --data-urlencode "db=newfiesdialer" --data-urlencode "q=SELECT \"value\" FROM \"freeswitch_channels_cpg_total\""


## Todo

List of improvements and tasks,

- [ ] use [conform](https://github.com/bitwalker/conform) to support config file
- [ ] add inch_ex
- [ ] add credo - https://github.com/rrrene/credo
