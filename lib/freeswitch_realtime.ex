defmodule FSRealtime do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger
  alias FSRealtime.InConnection

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    log_app_info()

    # Define workers and child supervisors to be supervised
    children = [
      # Starts worker by calling:FSRealtime.Worker.start_link(arg1, arg2, arg3)
      # worker(FSRealtime.Worker, [arg1, arg2, arg3]),
      supervisor(FSRealtime.Repo, []),
      worker(Collector, [[], [name: MyCollector]]),
      worker(PushInfluxDB, [0]),
      worker(PusherPG, [0]),
      # We dont use `Sqlitex.Server` as it's not possible to catch IO db errors
      # worker(Sqlitex.Server,
        # [Application.fetch_env!(:fs_realtime, :sqlite_db),
        # [name: Sqlitex.Server]]),
      InConnection.child_spec,
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [
      strategy: :one_for_one,
      max_restarts: 10,
      name: FSRealtime.Supervisor
    ]
    Supervisor.start_link(children, opts)
  end

  @doc """
  log_app_info will log Application information such as version and some settings
  """
  def log_app_info do
    {:ok, vsn} = :application.get_key(:fs_realtime, :vsn)
    app_version = List.to_string(vsn)
    {_, _, ex_ver} = List.keyfind(:application.which_applications, :elixir, 0)
    erl_version = :erlang.system_info(:otp_release)
    Logger.error "[starting] fs_realtime (app_version:#{app_version} - "
      <> "ex_ver:#{ex_ver} - erl_version:#{erl_version})"
    Logger.info "[init] we will collect channels information from "
      <> Application.fetch_env!(:fs_realtime, :sqlite_db)
  end

end
