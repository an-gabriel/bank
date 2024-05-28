defmodule BankWeb.AccountsController do
  @moduledoc """
  Controller for managing bank accounts.
  """

  use BankWeb, :controller

  alias Bank.Account.Context
  alias BankWeb.ErrorHandler

  require Logger

  @doc """
  Creates a new account.

  ## Parameters

  - `conn`: The connection struct.
  - `params`: A map containing the parameters for creating the account.
    - `account_number`: The account number.
    - `balance`: The account balance.

  """
  def create(conn, %{"account_number" => account_number, "balance" => balance}) do
    account_params = %{account_number: account_number, balance: balance}

    case Context.create(account_params) do
      {:ok, account} ->
        conn
        |> put_status(:created)
        |> json(%{account_number: account.account_number, balance: account.balance})

      {:error, reason} ->
        case reason do
          _ ->
            conn
            |> put_status(:gateway_timeout)
            |> json(%{error: reason})
            |> halt()
        end
    end
  end

  @doc """
  Lists all accounts.

  ## Parameters

  - `conn`: The connection struct.
  - `params`: Ignored in this method.

  """
  def list(conn, _params) do
    case Context.all([]) do
      {:ok, accounts} ->
        json(conn, %{accounts: accounts})

      {:error, reason} ->
        handle_error(conn, reason)
    end
  end

  @doc """
  Retrieves an account by account number.
  """
  def get_by_id(conn, _) do
    case Map.get(conn.params, "account_number") do
      nil ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Missing or empty account_number parameter"})

      "" ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Missing or empty account_number parameter"})

      account_number ->
        Logger.info("Received request for account_number: #{account_number}")

        case Context.get_account_by_number(account_number) do
          nil ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "Account not found"})

          account ->
            conn
            |> put_status(:ok)
            |> json(%{numero_conta: account.account_number, saldo: account.balance})
        end
    end
  rescue
    _ ->
      conn
      |> put_status(:internal_server_error)
      |> json(%{error: "Internal server error"})
  end

  defp handle_error(conn, error) do
    ErrorHandler.handle_errors(conn, error)
  end
end
