defmodule Servy.Recurse do
  def sum([h | t]) do
    h + sum(t)
  end

  def sum([]), do: 0

  def add(lst) do
    if lst == [] do
      raise "Empty list!"
    end

    do_add(lst, 0)
  end

  defp do_add([], acc), do: acc

  defp do_add([h | t], acc) do
    do_add(t, acc + h)
  end

  # NOT "tail-call optimized" (same function call is NOT the last argument)
  def triple([h | t]) do
    [
      h * 3
      | if t == [] do
          t
        else
          triple(t)
        end
    ]
  end

  def triple_alt([], acc), do: Enum.reverse(acc)

  # "tail-call optimized" (same function call as last argument)
  def triple_alt([h | t], acc) do
    triple_alt(t, [h * 3 | acc])
  end
end
