defmodule ChannelSeries do
  use Instream.Series

  series do
    database    Application.fetch_env!(:fs_channels, :influxdatabase)
    measurement "channels"

    tag :host, default: "127.0.0.1"
    tag :campaign_id, default: 0
    tag :user_id, default: 0
    tag :used_gateway_id, default: 0

    field :value, default: 0
  end
end

# defmodule AggrChannelSeries do
#   use Instream.Series

#   series do
#     database    "newfiesdialer"
#     measurement "aggr_channels"

#     tag :host, default: "127.0.0.1"

#     field :value, default: 0
#   end
# end
