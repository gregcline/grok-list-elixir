# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GrokStore.Repo.insert!(%GrokStore.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias GrokStore.Groceries.{List, ListItem}
alias GrokStore.Accounts
alias GrokStore.Repo

{:ok, user} =
  %{"name" => "Scraps", "email" => "an_email@thing.com", "password" => "a password"}
  |> Accounts.create_user()

list = %List{title: "My grocery list"} |> Repo.insert!()
list_2 = %List{title: "Other grok list"} |> Repo.insert!()

user
|> Repo.preload(:lists)
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:lists, [list])
|> Repo.update!()

%ListItem{
  text: "Spaghetti sauce",
  price: 3.99,
  quantity: 2.0,
  list_id: list.id
}
|> Repo.insert!()

%ListItem{
  text: "salmon",
  price: 15.0,
  quantity: 1.0,
  list_id: list.id
}
|> Repo.insert!()
