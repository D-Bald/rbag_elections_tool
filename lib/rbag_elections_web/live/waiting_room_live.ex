defmodule RbagElectionsWeb.WarteRaumLive do
  use RbagElectionsWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl text-center">
      <.header>
        Wartezimmer
      </.header>
      <p class="text-lg mt-4">Geht gleich weiter.</p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
