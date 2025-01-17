defmodule RbagElectionsWeb.AbgabeLive.FormComponent do
  use RbagElectionsWeb, :live_component

  alias RbagElections.Abstimmungen

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage abgabe records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="abgabe-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <:actions>
          <.button phx-disable-with="Saving...">Save Abgabe</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{abgabe: abgabe} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Abstimmungen.change_abgabe(abgabe))
     end)}
  end

  @impl true
  def handle_event("validate", %{"abgabe" => abgabe_params}, socket) do
    changeset = Abstimmungen.change_abgabe(socket.assigns.abgabe, abgabe_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"abgabe" => abgabe_params}, socket) do
    save_abgabe(socket, socket.assigns.action, abgabe_params)
  end

  defp save_abgabe(socket, :edit, abgabe_params) do
    case Abstimmungen.update_abgabe(socket.assigns.abgabe, abgabe_params) do
      {:ok, abgabe} ->
        notify_parent({:saved, abgabe})

        {:noreply,
         socket
         |> put_flash(:info, "abgabe updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_abgabe(socket, :new, abgabe_params) do
    case Abstimmungen.create_abgabe(abgabe_params) do
      {:ok, abgabe} ->
        notify_parent({:saved, abgabe})

        {:noreply,
         socket
         |> put_flash(:info, "abgabe created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
