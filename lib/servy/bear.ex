defmodule Servy.Bear do
  defstruct id: nil, name: "", type: "", hibernating: false

  def grizzly?(bear) do
    bear.type == "Grizzly"
  end

  def order_by_name_asc(a, b) do
    a.name <= b.name
  end
end
