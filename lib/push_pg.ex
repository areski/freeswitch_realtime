defmodule PusherPG do
  use GenServer
  require Logger

  alias Ecto.Adapters.SQL
  alias FSRealtime.Repo

  @moduledoc """
  GenServer Module to push Channels info to PostgreSQL.
  """

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(args) do
    {:ok, args}
  end

  @doc """
  Build query for update

  ## Examples

      iex> PusherPG.build_query_update_rtinfo(1)
      INSERT INTO dialer_campaign_rtinfo (current_channels_aleg, current_channels_bleg, campaign_id, host, created_date, updated_date) VALUES ($1, 0, $2, $3, NOW(), NOW()) ON CONFLICT (campaign_id, host) DO UPDATE SET current_channels_aleg = $1, updated_date=NOW()
  """
  @spec build_query_update_rtinfo(integer) :: String.t() | charlist
  def build_query_update_rtinfo(leg_type) when leg_type == 1 do
    "INSERT INTO dialer_campaign_rtinfo \
        (current_channels_aleg, current_channels_bleg, campaign_id, host, \
        created_date, updated_date) VALUES ($1, 0, $2, $3, NOW(), NOW()) \
        ON CONFLICT (campaign_id, host) \
        DO UPDATE SET current_channels_aleg = $1, updated_date=NOW()"
  end

  def build_query_update_rtinfo(leg_type) when leg_type == 2 do
    "INSERT INTO dialer_campaign_rtinfo \
        (current_channels_aleg, current_channels_bleg, campaign_id, host, \
        created_date, updated_date) VALUES (0, $1, $2, $3, NOW(), NOW()) \
        ON CONFLICT (campaign_id, host) \
        DO UPDATE SET current_channels_bleg = $1, bleg_updated_date=NOW()"
  end

  def build_query_update_rtinfo(_), do: false

  @doc """
  Update Campaign Channels information

  ## Examples

      iex> PusherPG.raw_update_campaign_rt([count: 3, campaign_id: 1, leg_type: 1])
      :ok
  """
  @spec raw_update_campaign_rt([{atom, integer}]) :: {:ok, binary} | {:error, any()}
  def raw_update_campaign_rt(channel_info) do
    Logger.debug(fn ->
      "Raw update Campaign RT #{inspect(channel_info)}..."
    end)

    querystring = build_query_update_rtinfo(channel_info[:leg_type])

    if querystring do
      SQL.query(Repo, querystring, [
        channel_info[:count],
        # 244,
        channel_info[:campaign_id],
        Application.fetch_env!(:fs_realtime, :local_host)
      ])
    end
  end

  @doc """
  Update Campaign Channels information

  ## Examples

      iex> PusherPG.apply_campaign_rt_update_map(
        [[count: 3, campaign_id: 1, leg_type: 1],
        [count: 3, campaign_id: 2, leg_type: 1]])
      :ok
  """
  @spec apply_campaign_rt_update_map([[{atom, integer}]]) :: [any()]
  def apply_campaign_rt_update_map(aggr_channel)
      when is_list(aggr_channel) and length(aggr_channel) > 0 do
    aggr_channel |> Enum.map(&raw_update_campaign_rt/1)
  end

  def apply_campaign_rt_update_map(_) do
    []
  end

  @doc """
  Async update CampaignRT Info (channels)
  """
  def async_update_campaign_rt(result) do
    GenServer.cast(__MODULE__, {:update_campaign_rt, result})
  end

  def handle_cast({:update_campaign_rt, result}, state) do
    apply_campaign_rt_update_map(result)
    {:noreply, state}
  end


  def terminate(_reason, state) do
    # Do Shutdown Stuff
    Logger.error(fn ->
      "terminate - going down - #{inspect(state)}"
    end)

    Process.sleep(1000)
    :normal
  end

  # catch for others handle_event
  def handle_event(event, state) do
    Logger.error("PusherPG: Got not expected handle_event: #{inspect(event)}")
    {:ok, state}
  end
end
