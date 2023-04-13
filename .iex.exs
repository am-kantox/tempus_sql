global_settings = Path.expand("~/.iex.exs")
if File.exists?(global_settings), do: Code.require_file(global_settings)

alias Ecto.Adapters.SQL
alias Tempus.SQL.Repo

import Tempus.Ecto.Query.API.Composite
import Tempus.Ecto.Query.API

import Ecto
import Ecto.Query

Repo.start_link()

ny_2020 = %Tempus.Slot{from: ~U[2020-01-01 00:00:00Z], to: ~U[2020-01-01 23:59:59.999999Z]}
ny_2050 = %Tempus.Slot{from: ~U[2050-01-01 00:00:00Z], to: ~U[2050-01-01 23:59:59.999999Z]}
eastern = %Tempus.Slot{from: ~U[2023-04-07 00:00:00Z], to: ~U[2023-04-10 23:59:59.999999Z]}
