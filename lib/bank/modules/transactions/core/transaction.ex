defmodule Bank.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:account_number, :amount, :payment_type]}
  schema "transactions" do
    field :account_number, :float
    field :amount, :float
    field :payment_type, Ecto.Enum, values: [:P, :C, :D]
    timestamps()
  end

  def permission(:public), do: [:id, :account_number, :amount, :payment_type]

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs,  [:account_number, :amount, :payment_type])
    |> validate_required( [:account_number, :amount, :payment_type])
  end
end
