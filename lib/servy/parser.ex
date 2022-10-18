defmodule Servy.Parser do
  def parse(request, http_version) do
    [method, path, ^http_version] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, status: nil, resp_body: ""}
  end
end
