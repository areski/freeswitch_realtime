defmodule FSChannelsCampaignSeries do
  use Instream.Series

  series do
    database    Application.fetch_env!(:fs_realtime, :influxdatabase)
    measurement "freeswitch_channels_cpg_total"

    tag :host, default: "127.0.0.1"
    tag :campaign_id, default: 0
    tag :leg_type, default: 1
    # tag :user_id, default: 0
    # tag :used_gateway_id, default: 0

    field :value, default: 0
  end
end

defmodule FSChannelsSeries do
  use Instream.Series

  series do
    database    Application.fetch_env!(:fs_realtime, :influxdatabase)
    measurement "freeswitch_channels_total"

    tag :host, default: "127.0.0.1"
    tag :leg_type, default: 1

    field :value, default: 0
  end
end
