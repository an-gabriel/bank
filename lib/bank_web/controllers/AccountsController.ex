defmodule BankWeb.AccountsController do
  @moduledoc """
  Controller for managing bank accounts.
  """

  use BankWeb, :controller

  alias Bank.Account.Context
  alias BankWeb.ErrorHandler

  @doc """
  Creates a new account.

  ## Parameters

  - `conn`: The connection struct.
  - `params`: A map containing the parameters for creating the account.
    - `account_number`: The account number.
    - `balance`: The account balance.

  """
  def create(conn, %{"account_number" => account_number, "balance" => balance}) do
    try do
      account_params = %{account_number: account_number, balance: balance}
      {:ok, account} = Context.create(account_params)

      conn
      |> put_status(:created)
      |> json(%{account_number: account.account_number, balance: account.balance})
    rescue
      error -> handle_error(conn, error)
    end
  end

  @doc """
  Lists all accounts.

  ## Parameters

  - `conn`: The connection struct.
  - `params`: Ignored in this method.

  """
  def list(conn, _params) do
    try do
      accounts = Context.all([])
      json(conn, %{accounts: accounts})
    rescue
      error -> handle_error(conn, error)
    end
  end

  defp handle_error(conn, error) do
    ErrorHandler.handle_errors(conn, error)
  end
end
