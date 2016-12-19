defmodule FreeswitchRealtime do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: FreeswitchRealtime.Worker.start_link(arg1, arg2, arg3)
      # worker(FreeswitchRealtime.Worker, [arg1, arg2, arg3]),
      worker(Collector, [[], [name: MyCollector]]),
      # worker(Pusher, [[], [name: MyPusher]]),
      worker(Pusher, [0]),
      # We dont use `Sqlitex.Server` as it's not possible to catch errors on reading/opening the database
      # worker(Sqlitex.Server, [Application.fetch_env!(:freeswitch_realtime, :sqlite_db), [name: Sqlitex.Server]]),
      FreeswitchRealtime.InConnection.child_spec,
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, max_restarts: 10, name: FreeswitchRealtime.Supervisor]
    Supervisor.start_link(children, opts)

  end
end
