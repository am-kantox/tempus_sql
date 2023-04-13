defmodule TempusSqlTest do
  use Tempus.SQL.RepoCase
  use Tempus.Ecto.Query.API, adapter: Tempus.Ecto.Query.API.Composite

  doctest Tempus.Ecto.Query.API

  describe "Query.API helpers" do
    setup do
      ny_2020 = %Tempus.Slot{from: ~U[2020-01-01 00:00:00Z], to: ~U[2020-01-01 23:59:59.999999Z]}
      ny_2050 = %Tempus.Slot{from: ~U[2050-01-01 00:00:00Z], to: ~U[2050-01-01 23:59:59.999999Z]}
      eastern = %Tempus.Slot{from: ~U[2023-04-07 00:00:00Z], to: ~U[2023-04-10 23:59:59.999999Z]}

      {:ok, _} = Repo.insert(%Occasion{initial: eastern, name: "initial_only"})
      {:ok, _} = Repo.insert(%Occasion{initial: eastern, settled: ny_2050, name: "initial_hint"})

      [ny_2020: ny_2020, ny_2050: ny_2050, eastern: eastern]
    end

    test "select by currency(-ies)", %{ny_2020: ny_2020, ny_2050: ny_2050, eastern: eastern} do
      assert [%Tempus.Slot{from: ~U[2023-04-07 00:00:00Z], to: ~U[2023-04-10 23:59:59.999999Z]}] =
               Occasion
               |> where([o], started_after(o.initial, ^~U[2023-01-01 00:00:00Z]))
               |> IO.inspect()
               |> select([o], o.initial)
               |> Repo.all()
    end
  end
end
