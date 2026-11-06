defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    state = reset_state(socket, 0)
    {:ok, state}
  end

  def render(assigns) do
    ~H"""
    <main class="px-4 py-20 sm:px-6 lg:px-8">
      <h1 class="mb-4 text-4xl font-extrabold">Your score: {@score}</h1>
      <h2>
        {@message}
      </h2>
      <br />
      <h2>
        <%= if @correct do %>
          <.link
            class="btn btn-secondary"
            phx-click="again"
          >
            Play again!
          </.link>
        <% else %>
          <%= for n <- 1..10 do %>
            <.link
              class="btn btn-secondary"
              phx-click="guess"
              phx-value-number={n}
            >
              {n}
            </.link>
          <% end %>
          <.link
            class="btn btn-secondary"
            phx-click="restart"
            phx-value-score={0}
          >
            Restart?
          </.link>
        <% end %>
      </h2>
      <br />
      <h2>It's {@current_time}</h2>
      <h2>{@current_user.email}</h2>
    </main>
    """
  end

  def handle_event("again", _params, socket) do
    state = reset_state(socket, socket.assigns.score)
    {:noreply, state}
  end

  def handle_event("restart", _params, socket) do
    state = reset_state(socket, 0)
    {:noreply, state}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    number = socket.assigns.magic_number
    correct = String.to_integer(guess) == number

    message =
      if correct do
        "You win! The correct number was #{number}. Would you like to play again?"
      else
        "Your guess: #{guess}. Wrong. Guess again."
      end

    score =
      if correct do
        socket.assigns.score
      else
        valid_score(socket.assigns.score - 1)
      end

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        current_time: time(),
        correct: correct
      )
    }
  end

  defp reset_state(socket, score) do
    :rand.seed(:default)

    assign(
      socket,
      score: valid_score(score + 10),
      message: "Make a guess:",
      magic_number: magic_number(),
      correct: false,
      current_user: socket.assigns.current_scope.user,
      current_time: time()
    )
  end

  defp valid_score(score), do: max(score, 0)

  defp magic_number, do: Enum.take_random(1..10, 1) |> hd()

  defp time, do: DateTime.utc_now() |> to_string()
end
