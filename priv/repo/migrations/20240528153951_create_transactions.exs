defmodule Bank.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :payment_type, :integer
      add :account_number, :float
      add :amount, :float

      timestamps(type: :utc_datetime)
    end
  end
end
