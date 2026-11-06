defmodule PentoWeb.RatingLive.Form do
  use PentoWeb, :live_component

  alias Pento.Survey
  alias Pento.Survey.Rating

  import PentoWeb.RatingLive.Show,
    only: [
      filled_stars: 1,
      unfilled_stars: 1
    ]

  def handle_event("save", %{"rating" => rating_params}, socket) do
    save_rating(socket, rating_params)
  end

  def save_rating(socket, params) do
    params = Map.put(params, "product_id", socket.assigns.product.id)

    case Survey.create_rating(socket.assigns.current_scope, params) do
      {:ok, rating} ->
        product = %{socket.assigns.product | ratings: [rating]}
        send(self(), {:created_rating, product, socket.assigns.index})
        {:noreply, socket}

      {:error, changeset} ->
        {:no_reply, assign_form(socket, changeset)}
    end
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_rating()
      |> assign_form()

    {:ok, socket}
  end

  defp assign_rating(socket) do
    rating = %Rating{user_id: socket.assigns.current_scope.user.id}
    assign(socket, :rating, rating)
  end

  defp assign_form(socket, changeset \\ nil) do
    form =
      case changeset do
        nil ->
          current_scope = socket.assigns.current_scope
          rating = socket.assigns.rating
          to_form(Survey.change_rating(current_scope, rating))

        changeset ->
          to_form(changeset)
      end

    assign(socket, :form, form)
  end

  defp star_options() do
    [
      "#{filled_stars(5)}": 5,
      "#{filled_stars(4)}": 4,
      "#{filled_stars(3)}": 3,
      "#{filled_stars(2)}": 2,
      "#{filled_stars(1)}": 1
    ]
  end
end
