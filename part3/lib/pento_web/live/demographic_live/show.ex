defmodule PentoWeb.DemographicLive.Show do
  use PentoWeb, :html

  attr :demographic, :map, required: true

  def details(assigns) do
    ~H"""
    <div>
      <h2 class="font-medium text-2xl">
        Demographics {raw("&#x2713;")}
      </h2>
      <.table id="demographics" rows={[@demographic]}>
        <:col :let={demographic} label="Gender">
          {demographic.gender}
        </:col>
        <:col :let={demographic} label="Year of Birth">
          {demographic.year_of_birth}
        </:col>
      </.table>
    </div>
    """
  end
end
