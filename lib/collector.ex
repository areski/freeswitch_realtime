defmodule Collector do
  use GenServer
  require Logger

  @moduledoc """
  Collector module is in charge of orchestrating the collection and push of Channels info.
  """

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(state) do
    Process.send_after(self(), :timeout_1, 1 * 500) # 0.5 second
    {:ok, state}
  end

  def handle_info(:timeout_1, state) do
    # Do the work you desire here
    schedule_task() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_task do
    Process.send_after(self(), :timeout_1, 1 * 500) # 0.5 second

    if File.regular?(Application.fetch_env!(:fs_realtime, :sqlite_db)) do
      # Dispatch Task
      task_read_channels()
    else
      Logger.error "sqlite database not found: " <>
        Application.fetch_env!(:fs_realtime, :sqlite_db)
    end

    # current_date = :os.timestamp |> :calendar.now_to_datetime
    # Logger.debug "#{inspect current_date}"
  end

  defp task_read_channels do
    aggr_channel = get_channels_aggr()
    case aggr_channel do
      {:error, reason} ->
        Logger.error reason
      {:ok, []} ->
        Logger.info "aggregate channels is empty []"
      {:ok, nil} ->
        Logger.info "aggregate channels is nil"
      {:ok, _} ->
        PushInfluxDB.push_aggr_channel(aggr_channel)
        PusherPG.update_campaign_rt(aggr_channel)
    end
  end

  defp get_channels_aggr do
    case Sqlitex.open(Application.fetch_env!(:fs_realtime, :sqlite_db)) do
      {:ok, db} ->
        # Sqlitex.query(db,
        # "SELECT count(*) as count, campaign_id, user_id, used_gateway_id "
        # <> "FROM channels GROUP BY campaign_id, user_id, used_gateway_id;")
        Sqlitex.query(db,
                      "SELECT count(*) as count, campaign_id, leg_type " <>
                      "FROM channels WHERE leg_type > 0 GROUP BY campaign_id, leg_type;")
      {:error, reason} ->
        Logger.error reason
        {:error, reason}
    end
  end

  # defp get_channels_aggr_user do
  #   case Sqlitex.open(Application.fetch_env!(:fs_realtime, :sqlite_db)) do
  #     {:ok, db} ->
  #       Sqlitex.query(db,
  #         "SELECT count(*) as count, user_id FROM channels GROUP BY user_id;")
  #     {:error, reason} ->
  #       Logger.error #{inspect reason}
  #       {:error}
  #   end
  # end

  # defp get_channels_aggr_total do
  #   case Sqlitex.open(Application.fetch_env!(:fs_realtime, :sqlite_db)) do
  #     {:ok, db} ->
  #       Sqlitex.query(db, "SELECT count(*) as count FROM channels;")
  #     {:error, reason} ->
  #       Logger.error #{inspect reason}
  #       {:error}
  #   end
  # end

end
