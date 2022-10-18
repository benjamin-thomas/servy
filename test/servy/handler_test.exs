defmodule Servy.HandlerTest do
  use ExUnit.Case
  doctest Servy.Handler
  alias Servy.Handler

  test "hello" do
    request = """
    GET /wild-things HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    want = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """

    assert ^want = Handler.handle(request)
  end
end
