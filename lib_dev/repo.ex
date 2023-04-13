defmodule Tempus.SQL.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :tempus_sql,
    adapter: Ecto.Adapters.Postgres
end
