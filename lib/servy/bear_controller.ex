defmodule Servy.BearController do
  alias Servy.WildThings
  alias Servy.Bear
  alias Servy.BearView
  import Servy.View, only: [render: 3]

  # @templates_path = Path.join("templates", file <> ".html")

  def index(conv) do
    # Both below are equivalent:
    #   &Bear.grizzly?(&1)
    #   &Bear.grizzly?/1
    bears =
      WildThings.list_bears()
      |> Enum.sort(&Bear.order_by_name_asc/2)

    # render(conv, "index.eex", bears: bears)

    # use a pre-compiled template function
    %{conv | status: 200, resp_body: BearView.index(bears)}
  end

  def show(conv, id) do
    bear = WildThings.get_bear(id)

    if bear do
      render(conv, "show.eex", bear: bear)
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
