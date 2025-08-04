defmodule RbagElections.Freigabe.Token do
  use Ecto.Schema
  import Ecto.Changeset
  alias RbagElections.Freigabe.Token

  @rand_size 32

  @type id :: integer()
  @type t :: %__MODULE__{
          id: id() | nil,
          value: binary() | nil,
          besitzer: String.t() | nil,
          wahlfreigaben:
            [RbagElections.Freigabe.WahlFreigabe.t()] | Ecto.Association.NotLoaded.t() | nil,
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  schema "tokens" do
    field :value, :binary
    field :besitzer, :string

    has_many :wahlfreigaben, RbagElections.Freigabe.WahlFreigabe
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:value, :besitzer])
    |> validate_required([:value, :besitzer])
    |> unique_constraint(:value)
  end

  @doc """
  Generates a token value that will be stored in a signed place,
  such as session or cookie. As they are signed, those
  tokens do not need to be hashed.

  The reason why we store session tokens in the database, even
  though Phoenix already provides a session cookie, is because
  Phoenix' default session cookies are not persisted, they are
  simply signed and potentially encrypted. This means they are
  valid indefinitely, unless you change the signing/encryption
  salt.

  Therefore, storing them allows individual admin
  sessions to be expired. The token system can also be extended
  to store additional data, such as the device used for logging in.
  You could then use this information to display all valid sessions
  and devices in the UI and allow users to explicitly expire any
  session they deem invalid.
  """
  def build_session_token(besitzer) do
    value = :crypto.strong_rand_bytes(@rand_size)
    {value, %Token{value: value, besitzer: besitzer}}
  end
end
