defmodule RbagElections.Freigabe.Events do
  @moduledoc """
  Event types and protocol for Freigabe events
  """

  alias RbagElections.Wahlen.Wahl

  @doc """
  Protocol for handling common event behaviors
  """
  defprotocol WahlRelation do
    @spec wahl_id(t()) :: Wahl.id()
    def wahl_id(event)
  end

  defmodule FreigabeAngefragt do
    @type t :: %__MODULE__{
            wahl_freigabe: RbagElections.Freigabe.WahlFreigabe.t() | nil
          }
    defstruct [:wahl_freigabe]
  end

  defmodule FreigabeErteilt do
    @type t :: %__MODULE__{
            wahl_freigabe: RbagElections.Freigabe.WahlFreigabe.t() | nil
          }
    defstruct [:wahl_freigabe]
  end

  defmodule FreigabeAbgelehnt do
    @type t :: %__MODULE__{
            wahl_freigabe: RbagElections.Freigabe.WahlFreigabe.t() | nil
          }
    defstruct [:wahl_freigabe]
  end

  defimpl WahlRelation, for: FreigabeAngefragt do
    def wahl_id(event), do: event.wahl_freigabe.wahl_id
  end

  defimpl WahlRelation, for: FreigabeErteilt do
    def wahl_id(event), do: event.wahl_freigabe.wahl_id
  end

  defimpl WahlRelation, for: FreigabeAbgelehnt do
    def wahl_id(event), do: event.wahl_freigabe.wahl_id
  end
end
