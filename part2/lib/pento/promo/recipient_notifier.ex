defmodule Pento.Promo.RecipientNotifier do
  import Swoosh.Email

  alias Ecto.UUID
  alias Pento.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Pento", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver promo code to a recipient's email.
  """
  def deliver_promo_code(email, name) do
    deliver(email, "Promo Code 10% Off", """

    ==============================

    Hi #{name},

    A Pento user has sent you a promo code worth 10% off your first game purchase!

    Your code: #{UUID.generate()}

    ==============================
    """)
  end
end
