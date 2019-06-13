defmodule GrokStore.Repo.Migrations.CreateListItems do
  use Ecto.Migration

  def change do
    create table(:list_items) do
      add :text, :text
      add :checked, :boolean, default: false, null: false
      add :quantity, :integer
      add :price, :float
      add :location, :string
      add :list_id, references(:lists, on_delete: :nothing)

      timestamps()
    end

    create index(:list_items, [:list_id])
  end
end
