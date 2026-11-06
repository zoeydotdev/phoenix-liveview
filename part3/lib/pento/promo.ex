defmodule Pento.Promo do
  alias Pento.Promo.Recipient

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(recipient, attrs) do
    recipient
    |> change_recipient(attrs)
    |> Ecto.Changeset.apply_action(:update)
  end
end
