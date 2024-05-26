defmodule BankWeb.AccountsController do
  @moduledoc false

  use BankWeb, :controller

  def list(conn, _params) do
    json(conn, %{status: :ok})
  end
end
