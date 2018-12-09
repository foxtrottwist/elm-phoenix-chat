defmodule Vmeste.Repo do
  use Ecto.Repo,
    otp_app: :vmeste,
    adapter: Ecto.Adapters.Postgres
end
