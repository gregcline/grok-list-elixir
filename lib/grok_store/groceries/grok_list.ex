defmodule GrokStore.Groceries.GrokList do
  use Ecto.Schema
  import Ecto.Changeset
  alias GrokStore.Accounts.User

  schema "lists" do
    field :title, :string
    has_many :list_items, GrokStore.Groceries.ListItem, foreign_key: :list_id

    many_to_many(:users, User,
      join_through: "user_lists",
      on_replace: :delete,
      join_keys: [list_id: :id, user_id: :id]
    )

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
