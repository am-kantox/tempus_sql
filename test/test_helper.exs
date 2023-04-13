ExUnit.start()

alias Ecto.Adapters.SQL.Sandbox

{:ok, _pid} = Tempus.SQL.Repo.start_link()
:ok = Sandbox.mode(Tempus.SQL.Repo, :manual)

defmodule Tempus.SQL.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Tempus.SQL.Repo

      import Ecto
      import Ecto.Query
      import Tempus.SQL.RepoCase

      def seeds(_ctx) do
        ny_2020 = %Tempus.Slot{
          from: ~U[2020-01-01 00:00:00.000000Z],
          to: ~U[2020-01-01 23:59:59.999999Z]
        }

        ny_2050 = %Tempus.Slot{
          from: ~U[2050-01-01 00:00:00.000000Z],
          to: ~U[2050-01-01 23:59:59.999999Z]
        }

        eastern = %Tempus.Slot{
          from: ~U[2023-04-07 00:00:00.000000Z],
          to: ~U[2023-04-10 23:59:59.999999Z]
        }

        {:ok, _} = Repo.insert(%Occasion{initial: eastern, name: "initial_only"})

        {:ok, _} =
          Repo.insert(%Occasion{
            initial: eastern,
            suggested: ny_2020,
            settled: ny_2050,
            name: "full"
          })

        [ny_2020: ny_2020, ny_2050: ny_2050, eastern: eastern]
      end
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Tempus.SQL.Repo)

    unless tags[:async] do
      Sandbox.mode(Tempus.SQL.Repo, {:shared, self()})
    end

    :ok
  end
end
