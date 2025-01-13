defmodule RbagElectionsWeb.SubmissionLive.FormComponent do
  use RbagElectionsWeb, :live_component

  alias RbagElections.Submissions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage submission records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="submission-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Submission</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{submission: submission} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Submissions.change_submission(submission))
     end)}
  end

  @impl true
  def handle_event("validate", %{"submission" => submission_params}, socket) do
    changeset = Submissions.change_submission(socket.assigns.submission, submission_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"submission" => submission_params}, socket) do
    save_submission(socket, socket.assigns.action, submission_params)
  end

  defp save_submission(socket, :edit, submission_params) do
    case Submissions.update_submission(socket.assigns.submission, submission_params) do
      {:ok, submission} ->
        notify_parent({:saved, submission})

        {:noreply,
         socket
         |> put_flash(:info, "Submission updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_submission(socket, :new, submission_params) do
    case Submissions.create_submission(submission_params) do
      {:ok, submission} ->
        notify_parent({:saved, submission})

        {:noreply,
         socket
         |> put_flash(:info, "Submission created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
