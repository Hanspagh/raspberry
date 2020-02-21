defmodule OkoController.MqttHandler do
  use Tortoise.Handler

  def init(args) do
    :ets.new(:codes, [:set, :protected, :named_table])
    IO.inspect("init")
    {:ok, args}
  end

  def connection(status, state) do
    # `status` will be either `:up` or `:down`; you can use this to
    # inform the rest of your system if the connection is currently
    # open or closed; tortoise should be busy reconnecting if you get
    # a `:down`
    IO.inspect("connect")
    {:ok, state}
  end

  #  topic filter room/+/temp
  def handle_message(["code", box, drawer], code, state) do
    :ets.insert(:codes, {code, drawer})
    {:ok, state}
  end
  def handle_message(topic, payload, state) do
    IO.inspect("connect")
    # unhandled message! You will crash if you subscribe to something
    # and you don't have a 'catch all' matcher; crashing on unexpected
    # messages could be a strategy though.
    {:ok, state}
  end

  def subscription(status, topic_filter, state) do
    {:ok, state}
  end

  def terminate(reason, state) do
    # tortoise doesn't care about what you return from terminate/2,
    # that is in alignment with other behaviours that implement a
    # terminate-callback
    :ok
  end
end
