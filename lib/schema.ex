defmodule FreeswitchRealtime.CampaignRT do
  use Ecto.Schema

  # dialer_cdr is the DB table
  schema "dialer_campaign_rtinfo" do
    field :campaign_id,             :integer, default: 0
    field :current_channels_total,  :integer, default: 0
    field :updated_date,            Timex.Ecto.DateTime
  end
end

# alias FreeswitchRealtime.Repo
# alias FreeswitchRealtime.CampaignRT
# newrt = %CampaignRT{campaign_id: 1, current_channels_total: 20, updated_date: %Ecto.DateTime{year: 2015, month: 1, day: 23, hour: 23, min: 50, sec: 07, usec: 0}}
# Repo.insert!(newrt)
