defmodule BankWeb.AccountsController do
  @moduledoc false

  use BankWeb, :controller

  alias Bank.Account.Context

  def list(conn, params) do
    accounts = Context.all(params)

    json(conn, %{data: accounts})
  end
end
