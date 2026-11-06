defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view

  alias Pento.Catalog
  alias Pento.Survey
  alias PentoWeb.DemographicLive.Form
  alias PentoWeb.DemographicLive.Show
  alias __MODULE__.Component

  @impl true
  def handle_info({:created_demographic, demographic}, socket) do
    socket = handle_demographic_created(socket, demographic)
    {:noreply, socket}
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_demographic()
      |> assign_products()

    {:ok, socket}
  end

  defp assign_demographic(socket) do
    demographic = Survey.get_demographic_by_user(socket.assigns.current_scope)
    assign(socket, :demographic, demographic)
  end

  defp assign_products(socket) do
    products = Catalog.list_products(socket.assigns.current_scope)
    assign(socket, :products, products)
  end

  defp handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end
end
