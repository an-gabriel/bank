defmodule Bank.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :account_number, :integer
      add :balance, :float

      timestamps(type: :utc_datetime)
    end
  end
end
