defmodule RbagElectionsWeb.OptionHTML do
  use RbagElectionsWeb, :html

  embed_templates "option_html/*"

  @doc """
  Renders a option form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def option_form(assigns)
end
