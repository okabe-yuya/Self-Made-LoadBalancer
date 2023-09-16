defmodule HealthCheck.Active do
  @retry_count 1

  def exec({ servers, current }, endpoint, header, body) do
    host = Enum.at(servers, current).host
    url = URI.merge(host, endpoint) |> to_string()

    active_check(url, header, body, 0) |> update_server({ servers, current })
  end

  defp active_check(_url, _header, _body, count) when count >= @retry_count, do: { :error, nil }
  defp active_check(url, header, body, count) do
    { status, resp } = HttpClient.call(url, header, body)
    if status == 200 do
      { :ok, resp }
    else
      active_check(url, header, body, count + 1)
    end
  end

  defp update_server({ :ok, resp }, { servers, current }) do
    next_current = rem(current + 1, length(servers))
    { resp, { servers, next_current }}
  end
  defp update_server({ :error, nil }, { servers, current }) do
    next_current = rem(current + 1, length(servers))
    next_servers =  List.update_at(servers, current, fn s -> %{s | is_active: false } end)

    { nil, { next_servers, next_current } }
  end
end
