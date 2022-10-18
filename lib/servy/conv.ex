defmodule Servy.Conv do
  defstruct method: "", path: "", resp_body: "", status: nil

  def full_status(%__MODULE__{} = conv) do
    "#{conv.status} #{status_string(conv.status)}"
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
