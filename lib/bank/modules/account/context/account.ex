defmodule Bank.Account.Context do
  @moduledoc """
  Context module for managing bank accounts.
  """

  alias Bank.Accounts

  @doc """
  Retrieves all accounts.

  ## Parameters

  - `_params`: Ignorado neste método.

  ## Returns

  A list of all accounts.

  """
  def all(_params) do
    permission = :public

    Bank.Accounts.list_accounts()
    |> Enum.map(&Accounts.json(&1, permission))
  end

  @doc """
  Creates a new account.

  ## Parameters

  - `account_params`: A map containing the parameters for creating the account.
    - `account_number`: The account number.
    - `balance`: The account balance.

  ## Returns

  A tuple with the atom `:ok` and the created account details on success,
  or a tuple with the atom `:error` and the error message on failure.

  """
  def create(account_params) do
    Bank.Accounts.create_account(account_params)
  end
end
