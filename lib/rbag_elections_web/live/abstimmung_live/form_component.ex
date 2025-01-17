defmodule RbagElectionsWeb.AbstimmungLive.FormComponent do
  use RbagElectionsWeb, :live_component

  alias RbagElections.Abstimmungen

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage abstimmung records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="abstimmung-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Abstimmung</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{abstimmung: abstimmung} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Abstimmungen.change_abstimmung(abstimmung))
     end)}
  end

  @impl true
  def handle_event("validate", %{"abstimmung" => abstimmung_params}, socket) do
    changeset = Abstimmungen.change_abstimmung(socket.assigns.abstimmung, abstimmung_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"abstimmung" => abstimmung_params}, socket) do
    save_abstimmung(socket, socket.assigns.action, abstimmung_params)
  end

  defp save_abstimmung(socket, :edit, abstimmung_params) do
    case Abstimmungen.update_abstimmung(socket.assigns.abstimmung, abstimmung_params) do
      {:ok, abstimmung} ->
        notify_parent({:saved, abstimmung})

        {:noreply,
         socket
         |> put_flash(:info, "Abstimmung updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_abstimmung(socket, :new, abstimmung_params) do
    case Abstimmungen.create_abstimmung(abstimmung_params) do
      {:ok, abstimmung} ->
        notify_parent({:saved, abstimmung})

        {:noreply,
         socket
         |> put_flash(:info, "Abstimmung created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
