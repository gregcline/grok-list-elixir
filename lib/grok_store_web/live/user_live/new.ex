defmodule GrokStoreWeb.UserLive.New do
  use Phoenix.LiveView

  alias GrokStoreWeb.UserLive
  alias GrokStoreWeb.Router.Helpers, as: Routes
  alias GrokStore.Accounts
  alias GrokStore.Accounts.User

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user(%User{})
    {:ok, assign(socket, changeset: changeset)}
  end

  def render(assigns) do
    Phoenix.View.render(GrokStoreWeb.UserView, "new.html", assigns)
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      %User{}
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        {:stop,
         socket
         |> put_flash(:info, "User created")
         |> redirect(to: Routes.user_path(socket, :show, user))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
