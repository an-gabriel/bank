defmodule Bank.Accounts do
  @moduledoc """
  The Accounts.
  """

  import Ecto.Query, warn: false
  alias Bank.Repo
  alias Bank.Accounts.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates an account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Atualiza a conta com os atributos fornecidos.

  ## Parameters

  - `account`: A struct `%Account{}` da conta a ser atualizada.
  - `attrs`: Um mapa contendo os atributos para atualizar.

  ## Returns

  - `{:ok, %Account{}}`: A conta atualizada se bem-sucedida.
  - `{:error, %Ecto.Changeset{}}`: Um changeset com os erros se houver falhas na atualização.
  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  def json(model, permission) do
    Map.take(model, Account.permission(permission))
  end

  @doc """
  Gets an account by its account number.

  ## Parameters

  - `account_number`: The account number to search for.

  ## Returns

  - `%Account{}`: The account if found.
  - `nil`: If no account is found with the given account number.

  ## Examples

      iex> get_account_by_number("1234567890")
      %Account{}

      iex> get_account_by_number("0987654321")
      nil
  """
  def get_account_by_number(account_number) do
    Repo.one(from a in Account, where: a.account_number == ^account_number)
  end
end
