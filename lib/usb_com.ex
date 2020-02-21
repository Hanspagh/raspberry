defmodule OkoController.UsbCom do


  def init() do
    {:ok, pid} = Nerves.UART.start_link()
    Nerves.UART.open(pid, "/dev/cu.URT0", speed: 115200, active: false)
    Nerves.UART.write(pid, open_drawer(10))
  end

  def open_drawer(num) do
    <<0::1, 1::1, num::6 >>
  end

  def close_drawer(num) do
    <<0::1, 0::1, num::6 >>
  end

end
