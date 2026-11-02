defmodule PentoWeb.SurveyLive.Component do
  use Phoenix.Component

  attr :content, :string, required: true
  slot :inner_block, required: true

  def hero(assigns) do
    ~H"""
    <div class="hero bg-gradient-to-r from-blue-500 to-purple-600 text-white">
      <div class="hero-content text-center py-16">
        <div class="max-w-md">
          <h1 class="mb-5 text-5xl font-bold">{@content}</h1>
          <div class="mb-5 text-lg">
            {render_slot(@inner_block)}
          </div>
        </div>
      </div>
    </div>
    """
  end
end
