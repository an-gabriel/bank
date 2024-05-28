defmodule Bank.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bank.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        account_number: 120.5,
        amount: 120.5,
        payment_type: 42
      })
      |> Bank.Transactions.create_transaction()

    transaction
  end
end
