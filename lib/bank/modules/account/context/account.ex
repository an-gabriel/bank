defmodule Bank.Account.Context do
  @moduledoc false

  def all(_params) do
    Bank.Accounts.list_accounts()
  end


end
