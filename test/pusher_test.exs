defmodule PusherTest do
  use ExUnit.Case, async: true

  # setup do
  #   {:ok, genserver} = Pusher.start_link([])
  #   {:ok, genserver: genserver}
  # end

  # test "spawns buckets", %{genserver: genserver} do
  test "already start genserver" do
    assert Pusher.lookup("shopping") == :error

    assert Pusher.push("hello") == :ok

    assert Pusher.pop() == "hello"


    # Pusher.create(genserver, "shopping")
    # assert {:ok, bucket} = Pusher.lookup(genserver, "shopping")

    # KV.Bucket.put(bucket, "milk", 1)
    # assert KV.Bucket.get(bucket, "milk") == 1
  end
end