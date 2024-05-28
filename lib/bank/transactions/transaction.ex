defmodule Bank.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :account_number, :float
    field :amount, :float
    field :payment_type, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:payment_type, :account_number, :amount])
    |> validate_required([:payment_type, :account_number, :amount])
  end
end
