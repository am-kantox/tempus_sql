defmodule Tempus.SQL.Repo do
  use Ecto.Repo,
    otp_app: :tempus_sql,
    adapter: Ecto.Adapters.Postgres
end
