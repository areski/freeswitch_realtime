defmodule Collector do
  use GenServer
  require Logger

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(state) do
    Logger.debug "[init] we will collect channels information from " <> Application.fetch_env!(:fs_channels, :sqlite_db)
    Process.send_after(self(), :timeout_1, 1 * 1000) # 1 second
    {:ok, state}
  end

  def handle_info(:timeout_1, state) do
    # Do the work you desire here
    schedule_task() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_task() do
    Process.send_after(self(), :timeout_1, 1 * 1000) # 1 second
    current_date = :os.timestamp |> :calendar.now_to_datetime
    #{inspect reason}
    Logger.debug "#{inspect current_date}"
    # IO.inspect get_channels_aggr()
    cnt = get_channels_count()
    Logger.info "#{inspect cnt}"
  end

  def handle_call(:pop, _from, []) do
    raise "oops it's empty"
    {:reply, [], []}
  end

  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  def handle_cast({:push, h}, t) do
    {:noreply, [h | t]}
  end

  # defp get_channels_aggr() do
  #   Sqlitex.Server.query(Sqlitex.Server,
  #                    "SELECT count(*) as count, campaign_id, user_id, used_gateway_id FROM channels GROUP BY campaign_id, user_id, used_gateway_id;")
  # end

  defp get_channels_count() do
    case Sqlitex.open(Application.fetch_env!(:fs_channels, :sqlite_db)) do
      {:ok, db} ->
        Sqlitex.query(db, "SELECT count(*) FROM channels;")
      {:error, reason} ->
        Logger.error #{inspect reason}
        []
    end
  end

  defp get_channels_aggr() do
    case Sqlitex.open(Application.fetch_env!(:fs_channels, :sqlite_db)) do
      {:ok, db} ->
        Sqlitex.query(db, "SELECT count(*) as count, campaign_id, user_id, used_gateway_id FROM channels GROUP BY campaign_id, user_id, used_gateway_id;")
      {:error, reason} ->
        Logger.error #{inspect reason}
        []
    end
  end

end