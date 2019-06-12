defmodule GrokStore.Groceries.ListItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "list_items" do
    field :checked, :boolean, default: false
    field :location, :string
    field :price, :float
    field :quantity, :float
    field :text, :string
    belongs_to :list, GrokStore.Groceries.List

    timestamps()
  end

  @doc false
  def changeset(list_item, attrs) do
    list_item
    |> cast(attrs, [:text, :checked, :quantity, :price, :location])
    |> validate_required([:text, :checked, :quantity, :price])
  end
end
