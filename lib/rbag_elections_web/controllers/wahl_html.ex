defmodule RbagElectionsWeb.WahlHTML do
  use RbagElectionsWeb, :html

  embed_templates "wahl_html/*"

  @doc """
  Renders a wahl form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def wahl_form(assigns)
end
