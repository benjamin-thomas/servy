defmodule Servy.Handler do
  @http_version "HTTP/1.1"

  # alias Servy.Plugins
  import Servy.Plugins, only: [rewrite_path: 1, track: 1]
  import Servy.Parser, only: [parse: 2]

  alias Servy.FileHandler

  @doc """
  ## Examples

    iex> Servy.Handler.handle("GET /wild-things HTTP/1.1
    ...>Host: example.com
    ...>User-Agent: ExampleBrowser/1.0
    ...>Accept: */*
    ...>
    ...>")
    "HTTP/1.1 200 OK\\nContent-Type: text/html\\nContent-Length: 20\\n\\nBears, Lions, Tigers\\n"
  """
  def handle(request) do
    request
    |> parse(@http_version)
    |> rewrite_path()
    |> IO.inspect()
    |> route
    |> track()
    |> format_response()
  end

  def route(%{method: "GET", path: "/wild-things"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(%{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Bear ##{id}"}
  end

  def route(%{method: "GET", path: "/bears?" <> id} = conv) do
    route(%{conv | path: "/bears/#{id}"})
  end

  # @pages_dir Path.expand("../../pages", __DIR__)
  def route(%{method: "GET", path: "/pages" <> file} = conv) do
    # @pages_dir
    # |> Path.join(file <> ".html")
    # |> File.read()
    # |> FileHandler.handle_file(conv)

    # Mix *always* runs from the project's root directory.
    Path.join("pages", file <> ".html")
    |> File.read()
    |> FileHandler.handle_file(conv)
  end

  # def route(%{method: "GET", path: "/about"} = conv) do
  #   file =
  #     Path.expand("../../pages", __DIR__)
  #     |> Path.join("about.html")

  #   case File.read(file) do
  #     {:ok, content} ->
  #       %{conv | status: 200, resp_body: content}

  #     {:error, :enoent} ->
  #       %{conv | status: 404, resp_body: "File not found!"}

  #     {:error, reason} ->
  #       %{conv | status: 500, resp_body: "File error: #{reason}"}
  #   end
  # end

  def route(%{method: "DELETE"} = conv) do
    %{conv | status: 403, resp_body: "Denied!"}
  end

  def route(%{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  defp format_response(conv) do
    # TODO: Use values in the map to create an HTTP response string
    """
    #{@http_version} #{conv.status} #{status_string(conv.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_string(status) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }
    |> Map.fetch!(status)
  end
end

request = """
GET /wild-things HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

# ---

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

# ---

request = """
GET /wat HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

# ---

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

# ---

request = """
GET /wild-life HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

# ---

request = """
GET /bears?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

# ---

request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

# ---

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

# ---

request = """
GET /pages/about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)
