defmodule PushInfluxDBTest do
  use ExUnit.Case, async: true

  # setup do
  #   {:ok, genserver} = PushInfluxDB.start_link([])
  #   {:ok, genserver: genserver}
  # end

  # test "spawns buckets", %{genserver: genserver} do
  test "already start genserver" do
    # assert PushInfluxDB.push("hello") == :ok
    # assert PushInfluxDB.pop() == "hello"
    assert 1 == 1

    # PushInfluxDB.create(genserver, "shopping")
    # assert {:ok, bucket} = PushInfluxDB.lookup(genserver, "shopping")
  end

  test "try" do
  end

end
