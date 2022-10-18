defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request, http_version) do
    [method, path, ^http_version] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %Conv{
      method: method,
      path: path
    }
  end
end
