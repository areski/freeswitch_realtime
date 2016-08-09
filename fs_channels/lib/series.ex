defmodule ChannelSeries do
  use Instream.Series

  series do
    database    Application.fetch_env!(:fs_channels, :influxdatabase)
    measurement "channels"

    tag :host, default: "127.0.0.1"
    tag :campaign_id
    tag :user_id
    tag :used_gateway_id

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
