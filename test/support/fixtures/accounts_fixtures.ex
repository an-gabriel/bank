defmodule Bank.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bank.Accounts` context.
  """

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        account_number: 42,
        balance: 120.5
      })
      |> Bank.Accounts.create_account()

    account
  end
end
