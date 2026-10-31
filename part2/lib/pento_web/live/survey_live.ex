defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view

  alias Pento.Catalog
  alias Pento.Survey
  alias PentoWeb.DemographicLive.Show
  alias __MODULE__.Component

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
end
