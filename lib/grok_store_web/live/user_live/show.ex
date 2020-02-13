defmodule GrokStoreWeb.UserLive.Show do
  use Phoenix.LiveView

  alias GrokStoreWeb.UserLive
  alias GrokStoreWeb.Router.Helpers, as: Routes
  alias GrokStore.Accounts
  alias Phoenix.LiveView.Socket

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    Phoenix.View.render(GrokStoreWeb.UserView, "show.html", assigns)
  end

  def handle_params(%{"id" => id}, _url, socket) do
    {:noreply, socket |> assign(id: id) |> fetch()}
  end

  defp fetch(%Socket{assigns: %{id: id}} = socket) do
    assign(socket, user: Accounts.get_user!(id))
  end
end
