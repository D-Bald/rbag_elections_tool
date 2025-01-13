defmodule RbagElectionsWeb.DurchgangLive.FormComponent do
  use RbagElectionsWeb, :live_component

  alias RbagElections.Wahlleitung

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage durchgang records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="durchgang-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:status]} type="text" label="Status" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Durchgang</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{durchgang: durchgang} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Wahlleitung.change_durchgang(durchgang))
     end)}
  end

  @impl true
  def handle_event("validate", %{"durchgang" => durchgang_params}, socket) do
    changeset = Wahlleitung.change_durchgang(socket.assigns.durchgang, durchgang_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"durchgang" => durchgang_params}, socket) do
    save_durchgang(socket, socket.assigns.action, durchgang_params)
  end

  defp save_durchgang(socket, :edit, durchgang_params) do
    case Wahlleitung.update_durchgang(socket.assigns.durchgang, durchgang_params) do
      {:ok, durchgang} ->
        notify_parent({:saved, durchgang})

        {:noreply,
         socket
         |> put_flash(:info, "Durchgang updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_durchgang(socket, :new, durchgang_params) do
    case Wahlleitung.create_durchgang(durchgang_params) do
      {:ok, durchgang} ->
        notify_parent({:saved, durchgang})

        {:noreply,
         socket
         |> put_flash(:info, "Durchgang created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
