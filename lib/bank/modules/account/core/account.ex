defmodule Bank.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :account_number, :integer
    field :balance, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:account_number, :balance])
    |> validate_required([:account_number, :balance])
  end
end
