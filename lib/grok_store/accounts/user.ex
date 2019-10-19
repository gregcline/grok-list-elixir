defmodule GrokStore.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias GrokStore.Groceries.List
  alias Argon2

  schema "users" do
    field :email, :string
    field :name, :string
    field :passhash, :string
    field :password, :string, virtual: true

    many_to_many(:lists, List, join_through: "user_lists", on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :passhash, :password])
    |> validate_required([:name, :email, :passhash, :password])
  end

  @doc false
  def create_user_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, passhash: Argon2.hash_pwd_salt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
