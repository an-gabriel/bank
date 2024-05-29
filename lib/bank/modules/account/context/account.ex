defmodule Bank.Account.Context do
  @moduledoc """
  Context module for managing bank accounts.
  """
  alias Bank.Repo
  alias Bank.Accounts.Account
  alias Bank.Accounts
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

    case validate_balance(account_number, amount) do
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

  defp validate_balance(account_number, amount) do
    with :ok <- check_negative_balance(amount),
         {:ok, _account} <- Bank.Accounts.get_account_by_number(account_number) do
      :ok
    else
      :error -> {:error, "Invalid account number or the balance cannot be negative."}
      {:error, _} -> {:error, "The balance cannot be negative."}
    end
  end

  defp check_negative_balance(amount) when amount < 0 do
    {:error, "The balance cannot be negative."}
  end

  defp check_negative_balance(_amount) do
    :ok
  end

  @doc """
  Gets an account by its account number.

  ## Parameters

  - `account_number`: The account number to search for.

  ## Returns

  - `%Account{}`: The account if found.
  - `nil`: If no account is found with the given account number.

  ## Examples

      iex> get_account_by_number("1234567890")
      %Account{}

      iex> get_account_by_number("0987654321")
      nil
  """
  def get_account_by_number(account_number) do
    Bank.Accounts.get_account_by_number(account_number)
  end

  @doc """
  Atualiza o saldo de uma conta.

  ## Parameters

  - `account_number`: O número da conta.
  - `new_balance`: O novo saldo a ser atualizado.

  ## Returns

  - `{:ok, %Account{}}`: A conta atualizada se bem-sucedida.
  - `{:error, reason}`: Uma razão em caso de falha.

  """
  def update_balance(account_number, new_balance) do
    case Accounts.get_account_by_number(account_number) do
      nil ->
        {:error, "Account not found."}

      %Account{} = account ->
        case Accounts.update_account(account, %{balance: new_balance}) do
          {:ok, updated_account} ->
            {:ok, updated_account}

          {:error, reason} ->
            {:error, reason}
        end
    end
  end

end
