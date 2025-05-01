defmodule RbagElectionsWeb.TokenRegistrationLive do
  use RbagElectionsWeb, :live_view

  alias RbagElections.Freigabe
  alias RbagElections.Freigabe.Token

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Teilnehmen
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/login"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:besitzer]} type="text" label="Name" required />

        <:actions>
          <.button phx-disable-with="Warte auf Bestätigung..." class="w-full">Teilnehmen</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Freigabe.change_token(%Token{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"token" => token_params}, socket) do
    changeset = Freigabe.change_token(%Token{}, token_params)
    {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}
  end

  def handle_event("validate", %{"token" => token_params}, socket) do
    changeset = Freigabe.change_token(%Token{}, token_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "token")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
