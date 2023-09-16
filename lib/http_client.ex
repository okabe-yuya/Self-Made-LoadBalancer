defmodule HttpClient do
  @enforce_keys [:url, :header, :body]
  defstruct [:url, :header, :body]

  def call(_url, _header, _body) do
    status = [200, 503, 503, 503, 503] |> Enum.random
    { status, {} }
  end
end
