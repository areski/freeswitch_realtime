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
        series = Enum.map(chan_result, fn(x) -> parse_channels x end)
        case series |> FsChannels.InConnection.write() do
          :ok ->
            Logger.info "wrote " <> (Enum.count(series) |> Integer.to_string) <> " points"
          _  ->
            Logger.error "error writing points"
            Logger.error "#{inspect series}"
        end

        # data = %ChannelSeries{}
        # data = %{ data | tags: %{ data.tags | campaign_id: 777, user_id: 770, used_gateway_id: 700 }}
        # data = %{ data | fields:    %{ data.fields | value: 7 }}
        # data |> FsChannels.InConnection.write()
    end
  end

  def parse_channels(data) do
    serie = %ChannelSeries{}
    serie = %{ serie | tags: %{ serie.tags | campaign_id: data[:campaign_id], user_id: data[:user_id], used_gateway_id: data[:used_gateway_id] }}
    serie = %{ serie | fields: %{ serie.fields | value: data[:count] }}
    serie
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