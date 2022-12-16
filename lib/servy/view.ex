defmodule Servy.View do
  def render(conv, name, bindings \\ []) do
    content =
      Path.join("templates", name)
      |> EEx.eval_file(bindings)

    %{conv | status: 200, resp_body: content}
  end
end
