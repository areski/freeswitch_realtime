defmodule Pusher do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def push_aggr_channel(result) do
    Logger.debug "pushing series..."
    case result do
      {:ok, chan_result} ->
        write_points(chan_result)
        write_total(chan_result)
    end
  end

  def write_points(chan_result) do
    series = Enum.map(chan_result, fn(x) -> parse_channels x end)
    # IO.inspect series
    case series |> FreeswitchRealtime.InConnection.write([async: true, precision: :seconds]) do
      :ok ->
        Logger.info "wrote " <> (Enum.count(series) |> Integer.to_string) <> " points"
      {:error, :econnrefused} ->
        Logger.error "error writing points"
      _  ->
        Logger.error "error writing points: #{inspect series}"
    end

    # data = %FSChannelsCampaignSeries{}
    # data = %{ data | tags: %{ data.tags | campaign_id: 777 }}
    # data = %{ data | fields:    %{ data.fields | value: 7 }}
    # data |> FreeswitchRealtime.InConnection.write()
  end

  def parse_channels(data) do
    serie = %FSChannelsCampaignSeries{}
    serie = %{ serie | tags: %{ serie.tags | campaign_id: data[:campaign_id] }}
    serie = %{ serie | fields: %{ serie.fields | value: data[:count] }}
    serie
  end

  def write_total(chan_result) do
    total = Enum.reduce(chan_result, 0, fn(x, acc) -> (x[:count]) end)
    serie = %FSChannelsSeries{}
    serie = %{ serie | fields: %{ serie.fields | value: total }}

    case serie |> FreeswitchRealtime.InConnection.write([async: true, precision: :seconds]) do
      :ok ->
        Logger.info "wrote total: #{total}"
      _  ->
        Logger.error "error writing total"
    end
  end

  def push(item) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  def lookup(item) do
    :error
  end


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