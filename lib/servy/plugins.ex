defmodule Servy.Plugins do
  def track(%{status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} is on the loose!")
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/wild-life"} = conv) do
    %{conv | path: "/wild-things"}
  end

  def rewrite_path(conv), do: conv
end
