defmodule Tempus.SQL.Map.Test do
  use Tempus.SQL.RepoCase
  use Tempus.Ecto.Query.API, adapter: Tempus.Ecto.Query.API.Map.Postgres

  doctest Tempus.Ecto.Query.API

  describe "Query.API helpers for map type" do
    setup :seeds

    test "select by suggested (map)", %{ny_2020: ny_2020} do
      assert [] =
               Occasion
               |> where([o], started_after(o.suggested, ny_2020.from))
               |> select([o], o.suggested)
               |> Repo.all()

      assert [^ny_2020] =
               Occasion
               |> where([o], started_after(o.suggested, DateTime.add(ny_2020.from, -1)))
               |> select([o], o.suggested)
               |> Repo.all()
    end
  end
end
