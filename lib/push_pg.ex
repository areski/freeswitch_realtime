defmodule PusherPG do
  use GenServer
  require Logger

  alias Ecto.Adapters.SQL
  alias FreeswitchRealtime.Repo

  @moduledoc """
  GenServer Module to push Channels info to PostgreSQL.
  """

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Update Campaign Channels information

  ## Examples

      iex> PusherPG.raw_update_campaign_rt([count: 3, campaign_id: 1, leg_type: 1])
      :ok
  """
  def raw_update_campaign_rt(channel_info) do
    Logger.debug "Raw update Campaign RT #{inspect channel_info}..."
    querystring = case channel_info[:leg_type] do
        1 ->
          "INSERT INTO dialer_campaign_rtinfo (current_channels_aleg, current_channels_bleg, campaign_id, host, created_date, updated_date) VALUES ($1, 0, $2, $3, NOW(), NOW())
           ON CONFLICT (campaign_id, host) DO UPDATE SET current_channels_aleg = $1, updated_date=NOW()"
        2 ->
          "INSERT INTO dialer_campaign_rtinfo (current_channels_aleg, current_channels_bleg, campaign_id, host, created_date, updated_date) VALUES (0, $1, $2, $3, NOW(), NOW())
           ON CONFLICT (campaign_id, host) DO UPDATE SET current_channels_bleg = $1, bleg_updated_date=NOW()"
      end
    SQL.query(Repo, querystring,
              [channel_info[:count], channel_info[:campaign_id], Application.fetch_env!(:freeswitch_realtime, :local_host)])
  end

  @doc """
  Update Campaign Channels information

  ## Examples

      iex> PusherPG.update_campaign_rt({:ok, [[count: 3, campaign_id: 1, leg_type: 1], [count: 3, campaign_id: 2, leg_type: 1]]})
      :ok
  """
  def update_campaign_rt({:ok, aggr_channel}) do
    # res = reduce_channels_map(aggr_channel)
    Enum.map(aggr_channel, &raw_update_campaign_rt/1)
  end

  @doc """
  Async update CampaignRT Info (channels)
  """
  def async_update_campaign_rt(result) do
    GenServer.cast(__MODULE__, {:update_campaign_rt, result})
  end

  def handle_cast({:update_campaign_rt, result}, state) do
    {:ok, _} = update_campaign_rt(result)
    {:noreply, state}
  end

  # !!! Not used at the moment - Not working...

  @doc """
  Reduce Campaign Channels information

  !!! Not used at the moment - Not working...

  ## Examples

      iex> PusherPG.reduce_channels_map([[count: 3, campaign_id: 1, leg_type: 1], [count: 2, campaign_id: 2, leg_type: 1], [count: 1, campaign_id: 2, leg_type: 2]])
      %{1 => [total_count: 3, aleg_count: 3, aleg_count: 3],
        2 => [total_count: 2, aleg_count: 3, bleg_count: 1]}

  """
  def reduce_channels_map(nil) do
    nil
  end
  """
  def reduce_channels_map(channels) do
    # IO.inspect channels
    reduce_channels =
        Enum.map(channels, fn x -> x[:campaign_id] end)
        |> Enum.uniq
        |> Enum.reduce(%{}, fn(x, acc) -> Map.merge(acc, %{x => [total_count: 0, aleg_count: 0, bleg_count: 0]}) end)

    for val <- channels do
      # Map.fetch(reduce_channels, val[:campaign_id])//

      total_count = if reduce_channels[val[:campaign_id]][:total_count] == nil do
        0 + val[:count]
      else
        reduce_channels[val[:campaign_id]][:total_count] + val[:count]
      end

      aleg_count = if reduce_channels[val[:campaign_id]][:aleg_count] == nil do
        0
      else
        reduce_channels[val[:campaign_id]][:aleg_count]
      end

      bleg_count = if reduce_channels[val[:campaign_id]][:bleg_count] == nil do
        0
      else
        reduce_channels[val[:campaign_id]][:bleg_count]
      end

      # /// Something not working...
      [aleg_count, bleg_count] = case val[:leg_type] do
        1 -> [aleg_count + val[:count], bleg_count]
        2 -> [aleg_count, bleg_count + val[:count]]
      end
      reduce_channels = Map.put(reduce_channels, val[:campaign_id],
                                [total_count: total_count, aleg_count: aleg_count, bleg_count: bleg_count])
    end
    reduce_channels
  end
  """

end