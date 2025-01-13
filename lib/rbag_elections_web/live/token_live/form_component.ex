defmodule RbagElectionsWeb.TokenLive.FormComponent do
  use RbagElectionsWeb, :live_component

  alias RbagElections.Freigabe

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage token records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="token-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:uuid]} type="text" label="Uuid" />
        <.input field={@form[:besitzer]} type="text" label="Besitzer" />
        <.input field={@form[:freigegeben]} type="checkbox" label="Freigegeben" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Token</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{token: token} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Freigabe.change_token(token))
     end)}
  end

  @impl true
  def handle_event("validate", %{"token" => token_params}, socket) do
    changeset = Freigabe.change_token(socket.assigns.token, token_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"token" => token_params}, socket) do
    save_token(socket, socket.assigns.action, token_params)
  end

  defp save_token(socket, :edit, token_params) do
    case Freigabe.update_token(socket.assigns.token, token_params) do
      {:ok, token} ->
        notify_parent({:saved, token})

        {:noreply,
         socket
         |> put_flash(:info, "Token updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_token(socket, :new, token_params) do
    case Freigabe.create_token(token_params) do
      {:ok, token} ->
        notify_parent({:saved, token})

        {:noreply,
         socket
         |> put_flash(:info, "Token created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
