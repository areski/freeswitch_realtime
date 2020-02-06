defmodule FSRealtime.Repo do
  use Ecto.Repo,
    otp_app: :fs_realtime,
    adapter: Ecto.Adapters.Postgres
end
