defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request, http_version) do
    [top, body] = String.split(request, "\n\n")

    [request_line | _headers] = String.split(top, "\n")

    [method, path, ^http_version] = String.split(request_line, " ")
    params = parse_params(body)

    %Conv{
      method: method,
      path: path,
      params: params
    }
  end

  def parse_params(params) do
    params |> String.trim() |> URI.decode_query()
  end
end
