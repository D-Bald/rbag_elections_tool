defmodule RbagElections.Freigabe.Events do
  defmodule FreigabeErteilt do
    defstruct wahl_freigabe: nil
  end

  defmodule FreigabeAbgelehnt do
    defstruct wahl_freigabe: nil
  end
end
