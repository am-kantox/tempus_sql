defmodule Tempus.SQL.Test do
  use Tempus.SQL.RepoCase
  use Tempus.Ecto.Query.API, adapter: Tempus.Ecto.Query.API.Composite

  doctest Tempus.Ecto.Query.API
end
