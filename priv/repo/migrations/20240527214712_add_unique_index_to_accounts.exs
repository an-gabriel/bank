defmodule Bank.Repo.Migrations.AddUniqueIndexToAccounts do
  use Ecto.Migration

  def change do
    create unique_index(:accounts, [:account_number])
  end
end
