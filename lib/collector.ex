defmodule Collector do
  use GenServer
  require Logger

  @moduledoc """
  Collector module is in charge of collecting and pushing of channels info
  """
  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(state) do
    Process.send_after(self(), :timeout_loop, 1000)
    {:ok, state}
  end

  def handle_info(:timeout_loop, state) do
    still_alive()
    schedule_task()
    # current_date = :os.timestamp |> :calendar.now_to_datetime
    # IO.inspect(current_date)

    # loop in 0.x seconds
    heartbeat = Application.fetch_env!(:fs_realtime, :heartbeat)
    Process.send_after(self(), :timeout_loop, heartbeat)

    # {:noreply, state}
    {:noreply, [], state}
  end

  @doc false
  def handle_info(_, state) do
    {:noreply, [], state}
  end

  @spec schedule_task :: :ok
  defp schedule_task do
    if File.regular?(Application.fetch_env!(:fs_realtime, :sqlite_db)) do
      process_channels()
    else
      Logger.error("sqlite db not found: " <> Application.fetch_env!(:fs_realtime, :sqlite_db))
    end

    # current_date = :os.timestamp |> :calendar.now_to_datetime
    # Logger.debug "#{inspect current_date}"
    :ok
  end

  def still_alive do
    randint = :rand.uniform(10)

    if randint <= 1 do
      Logger.info("still alive...")
    end
  end

  @doc """
  Task that read channels info and push it to InfluxDB & PG

  ## Examples

      iex> {:ok, :bingo}
      {:ok, :bingo}

  """
  @spec process_channels :: :ok
  defp process_channels do
    with {:ok, aggr_channel} <- get_channels_aggr(),
         # :ok <- Logger.info("#{inspect aggr_channel}"),
         :ok <- push_to_influxdb(aggr_channel),
         # :ok <- Logger.info("after async_push_aggr_channel"),
         do: {:ok, PusherPG.async_update_campaign_rt(aggr_channel)}

    :ok
  end

  @doc false
  defp push_to_influxdb(aggr_channel) do
    bypass_influx_freq = Application.fetch_env!(:fs_realtime, :bypass_influx_freq)
    randint = :rand.uniform(bypass_influx_freq)

    if randint <= 1 do
      # Logger.info("push_to_influxdb - aggr_channel:#{inspect(aggr_channel)}")
      PushInfluxDB.async_push_aggr_channel(aggr_channel)
    else
      Logger.info("bypass push_to_influxdb...")
    end
  end

  @doc false
  @spec get_channels_aggr :: {:ok, binary} | {:error, any()}
  defp get_channels_aggr do
    case Sqlitex.open(Application.fetch_env!(:fs_realtime, :sqlite_db)) do
      {:ok, db} ->
        Sqlitex.query(
          db,
          "SELECT count(*) as count, campaign_id, leg_type " <>
            "FROM channels WHERE leg_type > 0 GROUP BY campaign_id, leg_type;"
        )

      {:error, reason} ->
        Logger.error(reason)
        {:error, reason}
    end
  end

  # @doc false
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

  # @doc false
  # defp get_channels_aggr_total do
  #   case Sqlitex.open(Application.fetch_env!(:fs_realtime, :sqlite_db)) do
  #     {:ok, db} ->
  #       Sqlitex.query(db, "SELECT count(*) as count FROM channels;")
  #     {:error, reason} ->
  #       Logger.error #{inspect reason}
  #       {:error}
  #   end
  # end

  def terminate(_reason, state) do
    # Do Shutdown Stuff
    Logger.debug(fn ->
      "Going Down: #{inspect(state)}"
    end)

    # :timer.sleep(1000)
    Process.sleep(1000)
    :normal
  end

  # catch for others handle_event
  def handle_event(event, state) do
    Logger.error("Collector: Got not expected handle_event: #{inspect(event)}")
    {:ok, state}
  end
end
