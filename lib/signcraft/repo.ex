defmodule Signcraft.Repo do
  use Ecto.Repo,
    otp_app: :signcraft,
    adapter: Ecto.Adapters.Postgres
end
