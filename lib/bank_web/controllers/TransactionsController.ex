defmodule BankWeb.TransactionsController do
  @moduledoc """
  Controller for managing bank transactions.
  """

  use BankWeb, :controller

  alias Bank.Transaction.Context

  require Logger

  @payment_types [:PIX, :CREDIT_CARD, :DEBIT_CARD]

  @doc """
  Lists all transactions for a given account number.

  ## Parameters

  - `conn`: The connection struct.
  - `params`: Ignored in this method.

  """
  def list_transactions_by_account_number(conn, _params) do
    # Utilizando o atributo @payment_types
    Enum.each(@payment_types, fn payment_type ->
      Logger.info("Payment type: #{payment_type}")
    end)

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

        case Context.list_transactions_by_account_number(account_number) do
          [] ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "Transactions from this account were not found"})

          transactions ->
            conn
            |> put_status(:ok)
            |> json(%{transactions: transactions})
        end
    end
  end

  @doc """
  Creates a new transaction.

  ## Parameters

  - `conn`: The connection struct.
  - `params`: A map containing the parameters for creating the transaction.
    - `payment_type`: The payment type
      - :PIX => PIX
      - :CREDIT_CARD => CREDIT CARD
      - :DEBIT_CARD => DEBIT CARD
    - `account_number`: The account number.
    - `amount`: The transaction value.

  """
  def create(conn, %{
        "payment_type" => payment_type,
        "account_number" => account_number,
        "amount" => amount
      }) do
    transaction = %{
      payment_type: String.to_existing_atom(payment_type),
      account_number: account_number,
      amount: amount
    }

    case Context.create(transaction) do
      {:ok, new_transaction} ->
        conn
        |> put_status(:created)
        |> json(new_transaction)

      {:error, reason} ->
        conn
        |> put_status(:error)
        |> json(%{error: reason})
    end
  end
end
