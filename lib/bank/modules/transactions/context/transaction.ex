defmodule Bank.Transaction.Context do
  import Ecto.Query, warn: false
  alias Bank.Repo
  alias Bank.Transactions.Transaction
  alias Bank.Account.Context, as: AccountContext
  alias Bank.Accounts.Account

  require Logger

  # fee rate payment type
  @fee_rates %{
    "P" => 0.01,
    "C" => 0.02,
    "D" => 0.015
  }

  @doc """
  Returns all transactions for a given account number.
  """
  def get_transactions_by_account_number(account_number) do
    Transaction
    |> where([t], t.account_number == ^account_number)
    |> Repo.all()
  end

  @doc """
  Validates the account balance.
  """
  def validate_balance(account_number, amount) do
    case Bank.Accounts.get_account_by_number(account_number) do
      nil ->
        {:error, "Account not found"}

      %Account{balance: balance} ->
        if balance < amount do
          {:error, "Insufficient balance"}
        else
          :ok
        end
    end
  end

  @doc """
  Returns an account by account number.
  """
  def get_account(account_number) do
    case Bank.Accounts.get_account_by_number(account_number) do
      nil ->
        {:error, "Account not found"}

      %Account{} = account ->
        {:ok, account}
    end
  end

  @doc """
  Creates a new transaction with fees applied.

  ## Parameters

  - `account_params`: A map containing the parameters for creating the transaction.
    - `payment_type`: The payment type (P for PIX, C for Credit Card, D for Debit Card)
    - `account_number`: The account number
    - `amount`: The transaction value

  ## Returns

  A tuple with the atom `:ok` and the created transaction details on success,
  or a tuple with the atom `:error` and the error message on failure.
  """
  def create(account_params) do
    account_number = Map.get(account_params, :account_number)
    amount = Map.get(account_params, :amount)
    payment_type = Map.get(account_params, :payment_type) |> to_string()
    fee = calculate_fee(amount, payment_type)
    new_amount = amount - fee

    with {:ok, %Account{} = _account} <- get_account(account_number),
         :ok <- validate_balance(account_number, new_amount),
         {:ok, transaction} <-
           Bank.Transactions.create_transaction(Map.put(account_params, :amount, new_amount)),
         {:ok, _} <- AccountContext.update_balance(account_number, new_amount, payment_type) do
      {:ok, %{transaction | amount: new_amount}}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp calculate_fee(amount, payment_type) do
    case Map.get(@fee_rates, payment_type) do
      nil -> 0
      rate -> amount * rate
    end
  end
end
