defmodule PushInfluxDB do
  @moduledoc """
  Genserver Module to push channels information to InfluxDB
  """
  use GenServer
  require Logger
  alias FSRealtime.InConnection

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(args) do
    {:ok, args}
  end

  @doc """
  Channels dispatcher, get channels info and dispatch sub functions

  ## Examples

      iex> PushInfluxDB.push_aggr_channel(
        [[count: 3, campaign_id: 1, leg_type: 1],
        [count: 3, campaign_id: 2, leg_type: 1]])
      :ok

  """
  def push_aggr_channel(chan_result) when is_list(chan_result) and length(chan_result) > 0 do
    Logger.debug("pushing series...")
    write_points(chan_result)
    # Write total to influxDB for both Legs
    write_total(chan_result, 1)
    write_total(chan_result, 2)
    {:ok, :pushed}
  end

  def push_aggr_channel(_) do
    {:ok, nil}
  end

  @doc """
  Build Map Series for InfluxDB and write to InfluxDb

  ## Examples

      iex> PushInfluxDB.write_points(
        [[count: 3, campaign_id: 1, leg_type: 1],
        [count: 3, campaign_id: 2, leg_type: 1]])
      :ok

  """
  def write_points(chan_result) do
    series = Enum.map(chan_result, fn x -> parse_channels(x) end)

    case series |> InConnection.write(async: true, precision: :seconds) do
      :ok ->
        cnt = Enum.count(series)
        Logger.info("#{cnt} points")

      {:error, reason} ->
        Logger.error("error writing points - #{reason}")
    end
  end

  @doc """
  Build Series for InfluxDB

  Returns `%FSChannelsCampaignSeries`.

  ## Examples

      iex> PushInfluxDB.parse_channels([count: 3, campaign_id: 1, leg_type: 1])
      %FSChannelsCampaignSeries{fields: %FSChannelsCampaignSeries.Fields{value: 2},
        tags: %FSChannelsCampaignSeries.Tags{campaign_id: 3, host: "127.0.0.1"},
        timestamp: nil}
  """
  def parse_channels(data) do
    serie = %FSChannelsCampaignSeries{}

    serie = %{
      serie
      | tags: %{
          serie.tags
          | campaign_id: data[:campaign_id],
            leg_type: data[:leg_type],
            host: Application.fetch_env!(:fs_realtime, :local_host)
        }
    }

    serie = %{serie | fields: %{serie.fields | value: data[:count]}}
    serie
  end

  @doc """
  Write Total InfluxDB

  `leg_type` define which leg to write (1: aleg, 2: bleg)

  ## Examples

      iex> PushInfluxDB.write_total([
        [count: 3, campaign_id: 1, leg_type: 1],
        [count: 2, campaign_id: 1, leg_type: 2],
        [count: 3, campaign_id: 2, leg_type: 1],
        [count: 2, campaign_id: 3, leg_type: 1]
        ], 1)
      :ok
  """
  def write_total(chan_result, leg_type \\ 1) do
    leg? = &(&1[:leg_type] == leg_type)

    total_leg =
      chan_result
      |> Enum.filter(leg?)
      |> Enum.reduce(0, fn x, acc -> x[:count] + acc end)

    serie = %FSChannelsSeries{}

    serie = %{
      serie
      | tags: %{
          serie.tags
          | leg_type: leg_type,
            host: Application.fetch_env!(:fs_realtime, :local_host)
        }
    }

    serie = %{serie | fields: %{serie.fields | value: total_leg}}

    case serie |> InConnection.write(async: true, precision: :seconds) do
      :ok ->
        Logger.debug(fn ->
          "total: #{total_leg} on leg: #{leg_type}"
        end)

      _ ->
        Logger.error("error writing total")
    end
  end

  @doc """
  Async Push channels
  """
  def async_push_aggr_channel(result) do
    GenServer.cast(__MODULE__, {:push_aggr_channel, result})
  end

  def handle_cast({:push_aggr_channel, result}, state) do
    {:ok, _} = push_aggr_channel(result)
    {:noreply, state}
  end
end
