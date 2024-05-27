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
  Updates an existing account.

  ## Parameters

  - `conn`: The connection struct.
  - `id`: The ID of the account to update.
  - `params`: A map containing the parameters for updating the account.
    - `account_number`: The account number (optional).
    - `balance`: The account balance (optional).

  """
  def update(conn, %{"id" => id, "account_number" => account_number, "balance" => balance}) do
    account_params = %{account_number: account_number, balance: balance}

    case Context.update(id, account_params) do
      {:ok, updated_account} ->
        conn
        |> put_status(:ok)
        |> json(%{
          account_number: updated_account.account_number,
          balance: updated_account.balance
        })

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Conta não encontrada"})

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Não foi possível atualizar a conta", details: reason})
    end
  end

  defp handle_error(conn, error) do
    ErrorHandler.handle_errors(conn, error)
  end
end
