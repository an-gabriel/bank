defmodule Bank.AccountsTest do
  use Bank.DataCase

  alias Bank.Accounts

  describe "accounts" do
    alias Bank.Accounts.Account

    import Bank.AccountsFixtures

    @invalid_attrs %{account_number: nil, balance: nil}

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      valid_attrs = %{account_number: 42, balance: 120.5}

      assert {:ok, %Account{} = account} = Accounts.create_account(valid_attrs)
      assert account.account_number == 42
      assert account.balance == 120.5
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      update_attrs = %{account_number: 43, balance: 456.7}

      assert {:ok, %Account{} = account} = Accounts.update_account(account, update_attrs)
      assert account.account_number == 43
      assert account.balance == 456.7
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
