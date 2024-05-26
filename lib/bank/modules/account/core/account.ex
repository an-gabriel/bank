defmodule Bank.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:account_number, :balance]}
  schema "accounts" do
    field :account_number, :integer
    field :balance, :float

    timestamps(type: :utc_datetime)
  end

  def permission(:public), do: [:id, :account_number, :balance]

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:account_number, :balance])
    |> validate_required([:account_number, :balance])
  end
end
