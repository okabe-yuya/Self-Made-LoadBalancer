defmodule LoadBalancer do
  def launch do
    { :ok, s_pid } = GenServer.start_link(ServerState, nil, name: ServerState)
    spawn(fn -> passive_health_check() end)

    s_pid
  end

  def status do
    GenServer.call(ServerState, :status)
  end

  def request(endpoint, header, body) do
    GenServer.call(ServerState, { :active_health_check, endpoint, header, body })
  end

  def passive_health_check do
    :timer.sleep(5000)
    IO.puts(":::Health check...")
    GenServer.cast(ServerState, :passive_health_check)

    passive_health_check()
  end
end
