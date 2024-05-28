defmodule Bank.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  execute "CREATE TYPE payment_type AS ENUM ('P', 'C', 'D')"

  def change do
    create table(:transactions) do
      add :payment_type, :payment_type, null: false
      add :account_number, :float
      add :amount, :float

      timestamps(type: :utc_datetime)
    end
  end
end
