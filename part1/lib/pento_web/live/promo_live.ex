defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view

  alias Pento.Promo
  alias Pento.Promo.Recipient
  alias Pento.Promo.RecipientNotifier

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign_recipient()
      |> clear_form()
    }
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Send Your Promo Code to a Friend
        <:subtitle>
          Use this form to send a 10% off promo code for their first game purchase!
        </:subtitle>
      </.header>
      <div>
        <.form
          for={@form}
          id="promo-form"
          phx-change="validate"
          phx-submit="save"
        >
          <.input field={@form[:first_name]} type="text" label="First Name" />
          <.input field={@form[:email]} type="email" label="Email" />
          <footer>
            <.button phx-disable-with="Sending..." variant="primary">Send Promo</.button>
          </footer>
        </.form>
      </div>
      <div :if={local_mail_adapter?()} class="alert alert-info">
        <.icon name="hero-information-circle" class="size-6 shrink-0" />
        <div>
          <p>You are running the local mail adapter.</p>
          <p>
            To see sent emails, visit <.link href="/dev/mailbox" class="underline">the mailbox page</.link>.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  def clear_form(socket) do
    changeset =
      socket.assigns.recipient
      |> Promo.change_recipient()

    socket
    |> assign_form(changeset)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def handle_event(
        "validate",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    changeset =
      recipient
      |> Promo.change_recipient(recipient_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"recipient" => %{"email" => email, "first_name" => name}}, socket) do
    RecipientNotifier.deliver_promo_code(email, name)
    info = "Promo code sent via email to #{name}"

    {
      :noreply,
      socket
      |> put_flash(:info, info)
    }
  end

  defp local_mail_adapter? do
    Application.get_env(:pento, Pento.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
