defmodule PushInfluxDBTest do
  use ExUnit.Case, async: true

  # setup do
  #   {:ok, genserver} = PushInfluxDB.start_link([])
  #   {:ok, genserver: genserver}
  # end

  # test "spawns buckets", %{genserver: genserver} do
  test "already start genserver" do
    assert PushInfluxDB.lookup("shopping") == :error

    assert PushInfluxDB.push("hello") == :ok

    assert PushInfluxDB.pop() == "hello"


    # PushInfluxDB.create(genserver, "shopping")
    # assert {:ok, bucket} = PushInfluxDB.lookup(genserver, "shopping")

    # KV.Bucket.put(bucket, "milk", 1)
    # assert KV.Bucket.get(bucket, "milk") == 1
  end
end