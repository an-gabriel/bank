defmodule Bank.Account.Context do
  @moduledoc """
  Context module for managing bank accounts.
  """

  @doc """
  Retrieves all accounts.

  ## Parameters

  - `_params`: Ignored in this method.

  ## Returns

  A list of all accounts.

  """
  def all(_params) do
    case Bank.Accounts.list_accounts() do
      accounts when is_list(accounts) ->
        {:ok, accounts}
      _ ->
        {:error, "Failed to retrieve accounts."}
    end
  end

  @doc """
  Creates a new account.

  ## Parameters

  - `account_params`: A map containing the parameters for creating the account.
    - `account_number`: The account number.
    - `amount`: The initial account balance.

  ## Returns

  A tuple with the atom `:ok` and the created account details on success,
  or a tuple with the atom `:error` and the error message on failure.

  """
  def create(account_params) do
    account_number = Map.get(account_params, :account_number)
    amount = Map.get(account_params, :amount)

    case validate_balance(amount) do
      {:error, reason} ->
        {:error, reason}

      :ok ->
        case Bank.Accounts.get_account_by_number(account_number) do
          nil ->
            case Bank.Accounts.create_account(account_params) do
              {:ok, account} ->
                {:ok, account}
              {:error, reason} ->
                {:error, reason}
            end

          _ ->
            {:error, "The account already exists."}
        end
    end
  end

  defp validate_balance(amount) do
    if amount < 0 do
      {:error, "The balance cannot be negative."}
    else
      :ok
    end
  end
end
