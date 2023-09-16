defmodule HealthCheck.Passive do
  def exec(servers) do
    Enum.map(servers, fn server -> passive_check(server) end)
  end

  defp passive_check(server = %ServerState{ is_active: true }), do: server
  defp passive_check(server) do
    url = URI.merge(server.host, "/api/v1/health") |> to_string()
    { status, _resp } = HttpClient.call(url, {}, {})

    update_server(server, status)
  end

  defp update_server(server, status) when status == 200, do: server
  defp update_server(server, _status), do: %{server | is_active: false }
end
