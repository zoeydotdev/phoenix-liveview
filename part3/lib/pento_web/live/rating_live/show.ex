defmodule PentoWeb.RatingLive.Show do
  use PentoWeb, :html

  import Pento.Survey.Rating, only: [max_rating: 0]

  attr :rating, :map, required: true

  def stars(assigns) do
    filled = filled_stars(assigns.rating.stars)
    unfilled = unfilled_stars(assigns.rating.stars)
    all_stars = Enum.concat(filled, unfilled)
    star_display = Enum.join(all_stars, " ")
    assigns = assign(assigns, :star_display, star_display)

    ~H"""
    <div>{raw(@star_display)}</div>
    """
  end

  def filled_stars(stars), do: List.duplicate("★", stars)
  def unfilled_stars(stars), do: List.duplicate("☆", max_rating() - stars)
end
