defmodule RbagElectionsWeb.StimmeLive.FormComponent do
  use RbagElectionsWeb, :live_component

  alias RbagElections.Abstimmungen

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage stimme records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="stimme-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Stimme</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{stimme: stimme} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Abstimmungen.change_stimme(stimme))
     end)}
  end

  @impl true
  def handle_event("validate", %{"stimme" => stimme_params}, socket) do
    changeset = Abstimmungen.change_stimme(socket.assigns.stimme, stimme_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"stimme" => stimme_params}, socket) do
    save_stimme(socket, socket.assigns.action, stimme_params)
  end

  defp save_stimme(socket, :edit, stimme_params) do
    case Abstimmungen.update_stimme(socket.assigns.stimme, stimme_params) do
      {:ok, stimme} ->
        notify_parent({:saved, stimme})

        {:noreply,
         socket
         |> put_flash(:info, "Stimme updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_stimme(socket, :new, stimme_params) do
    case Abstimmungen.create_stimme(stimme_params) do
      {:ok, stimme} ->
        notify_parent({:saved, stimme})

        {:noreply,
         socket
         |> put_flash(:info, "Stimme created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
