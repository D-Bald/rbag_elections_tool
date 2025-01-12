defmodule RbagElectionsWeb.FrageHTML do
  use RbagElectionsWeb, :html

  embed_templates "frage_html/*"

  @doc """
  Renders a frage form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def frage_form(assigns)
end
