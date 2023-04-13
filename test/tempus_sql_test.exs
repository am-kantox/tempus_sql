defmodule TempusSqlTest do
  use ExUnit.Case
  doctest TempusSql

  test "greets the world" do
    assert TempusSql.hello() == :world
  end
end
