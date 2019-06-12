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
alias GrokStore.Repo

list = %List{title: "My grocery list"} |> Repo.insert!()

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
