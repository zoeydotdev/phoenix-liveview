defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view

  alias Pento.Catalog
  alias Pento.Survey
  alias PentoWeb.DemographicLive
  alias PentoWeb.RatingLive
  alias __MODULE__.Component

  @impl true
  def handle_info({:created_demographic, demographic}, socket) do
    socket = handle_demographic_created(socket, demographic)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:created_rating, product, product_index}, socket) do
    socket = handle_rating_created(socket, product, product_index)
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
    products =
      socket.assigns.current_scope.user
      |> Catalog.list_products_with_user_rating()

    assign(socket, :products, products)
  end

  defp handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end

  defp handle_rating_created(socket, product, product_index) do
    current_products = socket.assigns.products
    products = List.replace_at(current_products, product_index, product)

    socket
    |> put_flash(:info, "Rating created successfully")
    |> assign(:products, products)
  end
end
