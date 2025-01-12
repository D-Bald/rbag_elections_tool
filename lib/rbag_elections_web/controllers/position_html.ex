defmodule RbagElectionsWeb.PositionHTML do
  use RbagElectionsWeb, :html

  embed_templates "position_html/*"

  @doc """
  Renders a position form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def position_form(assigns)
end
