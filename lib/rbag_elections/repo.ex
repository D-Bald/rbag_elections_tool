defmodule RbagElections.Repo do
  use Ecto.Repo,
    otp_app: :rbag_elections,
    adapter: Ecto.Adapters.Postgres
end
