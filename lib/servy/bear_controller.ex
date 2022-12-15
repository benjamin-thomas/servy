defmodule Servy.BearController do
  alias Servy.WildThings
  alias Servy.Bear

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

  def index(conv) do
    # Both below are equivalent:
    #   &Bear.grizzly?(&1)
    #   &Bear.grizzly?/1
    items =
      WildThings.list_bears()
      |> Enum.filter(&Bear.grizzly?/1)
      |> Enum.sort(&Bear.order_by_name_asc/2)
      |> Enum.map(fn b -> bear_item(b) end)
      |> Enum.join()

    %{conv | status: 200, resp_body: "<ul>#{items}</ul>"}
  end

  def show(conv, id) do
    bear = WildThings.get_bear(id)

    if bear do
      %{conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>"}
    else
      %{conv | status: 404, resp_body: "Bear ##{id} does not exist!"}
    end
  end

  def create(conv, %{"type" => type, "name" => name}) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end

  def destroy(conv) do
    %{conv | status: 403, resp_body: "Denied!"}
  end
end
