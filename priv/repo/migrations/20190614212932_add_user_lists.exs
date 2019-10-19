defmodule GrokStore.Repo.Migrations.AddUserLists do
  use Ecto.Migration

  def change do
    create table(:user_lists, primary_key: false) do
      add(:user_id, references(:users, on_delete: :delete_all), primary_key: true)
      add(:list_id, references(:lists, on_delete: :delete_all), primary_key: true)
    end

    create(index(:user_lists, [:list_id]))
    create(index(:user_lists, [:user_id]))

    create(unique_index(:user_lists, [:user_id, :list_id], name: :user_id_list_id_unique_index))
  end
end
