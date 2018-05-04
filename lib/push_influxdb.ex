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

      iex> PushInfluxDB.push_aggr_channel({:ok,
        [[count: 3, campaign_id: 1, leg_type: 1],
        [count: 3, campaign_id: 2, leg_type: 1]]})
      :ok

  """
  def push_aggr_channel(result) do
    Logger.debug "pushing series..."
    case result do
      {:ok, chan_result} ->
        write_points(chan_result)
        # Write total to influxDB for both Legs
        write_total(chan_result, 1)
        write_total(chan_result, 2)
    end
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
    series = Enum.map(chan_result, fn(x) -> parse_channels x end)
    case series |> InConnection.write([async: true, precision: :seconds]) do
      :ok ->
        cnt = Enum.count(series)
        Logger.info "wrote #{cnt} points"
      {:error, :econnrefused} ->
        Logger.error "error writing points"
      _  ->
        Logger.error "error writing points: #{inspect series}"
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
    serie = %{serie | tags: %{serie.tags |
      campaign_id: data[:campaign_id],
      leg_type: data[:leg_type],
      host: Application.fetch_env!(:fs_realtime, :local_host)}}
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
    total_leg = chan_result
      |> Enum.filter(leg?)
      |> Enum.reduce(0, fn(x, acc) -> (x[:count] + acc) end)
    serie = %FSChannelsSeries{}
    serie = %{serie | tags: %{serie.tags | leg_type: leg_type,
              host: Application.fetch_env!(:fs_realtime, :local_host)}}
    serie = %{serie | fields: %{serie.fields | value: total_leg}}

    case serie |> InConnection.write([async: true, precision: :seconds]) do
      :ok ->
        Logger.info "wrote total: #{total_leg} on leg: #{leg_type}"
      _  ->
        Logger.error "error writing total"
    end
  end

  def push(item) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  # def lookup(item) do
  #  :error
  # end

  # Server (callbacks)
  # Sync
  def handle_call(:pop, _from, []) do
    {:reply, [], []}
  end

  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  # def handle_call(request, from, state) do
  #   # Call the default implementation from GenServer
  #   super(request, from, state)
  # end

  def handle_cast({:push, item}, state) do
    {:noreply, [item | state]}
  end

  # def handle_cast(request, state) do
  #   super(request, state)
  # end
end
