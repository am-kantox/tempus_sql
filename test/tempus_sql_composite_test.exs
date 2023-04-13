defmodule TempusSQL.Composite.Test do
  use Tempus.SQL.RepoCase
  use Tempus.Ecto.Query.API, adapter: Tempus.Ecto.Query.API.Composite

  describe "Query.API helpers for composite type" do
    setup :seeds

    test "select by initia / settled (composite)", %{ny_2050: ny_2050, eastern: eastern} do
      assert [^eastern, ^eastern] =
               Occasion
               |> where([o], started_after(o.initial, ~U[2023-01-01 00:00:00Z]))
               |> select([o], o.initial)
               |> Repo.all()

      assert [] =
               Occasion
               |> where([o], started_after(o.settled, ny_2050.from))
               |> select([o], o.settled)
               |> Repo.all()

      assert [^ny_2050] =
               Occasion
               |> where([o], started_after(o.settled, DateTime.add(ny_2050.from, -1)))
               |> select([o], o.settled)
               |> Repo.all()
    end
  end
end
