defmodule BankWeb.ErrorHandler do
  import Plug.Conn
  import Phoenix.Controller

  def handle_errors(conn, %Ecto.NoResultsError{}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "Not found"})
  end

  def handle_errors(conn, %ArgumentError{message: message}) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Invalid parameters: #{message}"})
  end

  def handle_errors(conn, nil) do
    conn
    |> put_status(:internal_server_error)
    |> json(%{error: "Internal server error: Unknown error"})
  end

  def handle_errors(conn, error) do
    conn
    |> put_status(:internal_server_error)
    |> json(%{error: "Internal server error: #{Exception.message(error)}"})
  end
end
