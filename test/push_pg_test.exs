defmodule PusherPGTest do
  use ExUnit.Case, async: true
  # doctest Collector
  alias FSRealtime.Repo
  alias Ecto.Adapters.SQL.Sandbox
  alias Ecto.Adapters.SQL

  setup do
    # Explicitly get a connection before each test
    :ok = Sandbox.checkout(Repo)
  end

  test "raw query" do
    result = SQL.query!(Repo, "SELECT NOW()")
    assert result.num_rows == 1
  end

  test "the truth" do
    assert 1 + 1 == 2
  end
end
