defmodule RbagElections.Abstimmungen.Events do
  defmodule AbgabeEingereicht do
    @type t :: %__MODULE__{
            token_id: RbagElections.Freigabe.Token.id() | nil
          }
    defstruct [:token_id]
  end
end
