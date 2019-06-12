defmodule GrokStore.Repo.Migrations.ChangeQuantityToFloat do
  use Ecto.Migration

  def change do
    alter table(:list_items) do
      modify :quantity, :float
    end
  end
end
