defmodule Bank.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def up do
    execute "CREATE TYPE payment_type AS ENUM ('P', 'C', 'D')"

    create table(:transactions) do
      add :payment_type, :payment_type, null: false
      add :account_number, :float
      add :amount, :float

      timestamps(type: :utc_datetime)
    end
  end

  def down do
    execute "DROP TYPE payment_type"
    drop table(:transactions)
  end
end
