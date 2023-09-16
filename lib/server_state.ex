defmodule ServerState do
  use GenServer

  @enforce_keys [:host, :is_active]
  defstruct [:host, :is_active]

  def init(_state) do
    servers = [
      %ServerState{ host: "http://localhost:3000", is_active: true },
      %ServerState{ host: "http://localhost:3001", is_active: true },
      %ServerState{ host: "http://localhost:3002", is_active: true },
    ]
    { :ok, { servers, 0 } }
  end

  def handle_call(:status, _from, state) do
    { :reply, state, state }
  end

  def handle_call({ :active_health_check, endpoint, header, body }, _from, state) do
    { resp, next } = HealthCheck.Active.exec(state, endpoint, header, body)
    { :reply, resp, next }
  end

  def handle_cast(:passive_health_check, { servers, current } ) do
    next = HealthCheck.Passive.exec(servers)
    { :noreply, { next, current } }
  end
end
