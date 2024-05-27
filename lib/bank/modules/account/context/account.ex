defmodule Bank.Account.Context do
  @moduledoc """
  Context module for managing bank accounts.
  """
  alias Bank.Repo
  alias Bank.Accounts.Account

  @doc """
  Retrieves all accounts.

  ## Parameters

  - `_params`: Ignored in this method.

  ## Returns

  A list of all accounts.

  """
  def all(_params) do
    {:ok, Repo.all(Account)}
  rescue
    e -> {:error, e.message}
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
    account_number = Map.get(account_params, :account_number)
    balance = Map.get(account_params, :balance)

    case validate_balance(balance) do
      {:error, reason} ->
        {:error, reason}

      :ok ->
        case get_account_or_nil(account_number) do
          nil -> Bank.Accounts.create_account(account_params)
          _ -> {:error, "The account already exists."}
        end
    end
  end

  defp validate_balance(balance) do
    if balance < 0 do
      {:error, "The balance cannot be negative."}
    else
      :ok
    end
  end

  defp get_account_or_nil(account_number) do
    get_account_by_number(account_number)
  end

  @doc """
  Updates an existing account.

  ## Parameters

  - `id`: The ID of the account to update.
  - `account_params`: A map containing the parameters for updating the account.

  ## Returns

  A tuple with the atom `:ok` and the updated account details on success,
  or a tuple with the atom `:error` and the error message on failure.

  """
  def update(id, account_params) do
    case get_account(id) do
      nil ->
        {:error, :not_found}

      account ->
        case Bank.Accounts.update_account(account, account_params) do
          {:ok, updated_account} -> {:ok, updated_account}
          {:error, reason} -> {:error, reason}
        end
    end
  end

  def get_account_by_number(account_number) do
    Repo.get_by(Account, account_number: account_number)
  end

  defp get_account(id) do
    Repo.get(Account, id)
  end
end
