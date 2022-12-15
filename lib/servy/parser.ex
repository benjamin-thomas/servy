defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request, http_version) do
    [top, body] = String.split(request, "\n\n")

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, ^http_version] = String.split(request_line, " ")
    headers = parse_headers(header_lines)
    params = parse_params(headers["Content-Type"], body)

    IO.inspect(header_lines)

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_params("application/x-www-form-urlencoded", params) do
    params |> String.trim() |> URI.decode_query()
  end

  def parse_params(_content_type, _params), do: %{}

  # def parse_headers([], headers), do: headers

  # def parse_headers([h | t], headers) do
  #   [k, v] = String.split(h, ": ")
  #   headers = Map.put(headers, k, v)
  #   parse_headers(t, headers)
  # end

  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn elem, acc ->
      [k, v] = String.split(elem, ": ")
      Map.put(acc, k, v)
    end)
  end
end
