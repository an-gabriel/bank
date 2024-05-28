defmodule Bank.Transaction.Context do
  import Ecto.Query, warn: false
  alias Bank.Repo
  alias Bank.Transactions.Transaction
  alias Bank.Accounts.Account

  @doc """
  Returns all transactions for a given account number.
  """
  def list_transactions_by_account_number(account_number) do
    Transaction
    |> where([t], t.account_number == ^account_number)
    |> Repo.all()
  end

  @doc """
  Validates the account balance.
  """
  def validate_balance(account_number, amount) do
    account = get_account_by_number(account_number)

    case account do
      nil ->
        {:error, "Account not found"}

      %Account{balance: balance} when balance < amount ->
        {:error, "Insufficient balance"}

      _ ->
        :ok
    end
  end

  @doc """
  Returns an account by account number.
  """
  def get_account_by_number(account_number) do
    Repo.get_by(Account, account_number: account_number)
  end

  @doc """
  Returns all transactions for a given account number.
  """
  def get_transactions_by_account_number(account_number) do
    Transaction
    |> where([t], t.account_number == ^account_number)
    |> Repo.all()
  end

  @doc """
  Creates a new transaction.

  ## Parameters

  - `account_params`: A map containing the parameters for creating the transaction.
    - `payment_type`: The payment type
      - P => PIX
      - C => CREDIT CARD
      - D => DEBIT CARD
    - `account_number`: The account number.
    - `amount`: The transaction value.

  ## Returns

  A tuple with the atom `:ok` and the created transaction details on success,
  or a tuple with the atom `:error` and the error message on failure.
  """
  def create(account_params) do
    account_number = Map.get(account_params, :account_number)
    amount = Map.get(account_params, :amount)

    case validate_balance(account_number, amount) do
      {:error, reason} ->
        {:error, reason}

      :ok ->
        case Bank.Transactions.create_transaction(account_params) do
          {:ok, transaction} ->
            {:ok, transaction}

          {:error, reason} ->
            {:error, reason}
        end
    end
  end
end
