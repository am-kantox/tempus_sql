defmodule Tempus.SQL do
  @moduledoc ~S"""
  The set of functions bringing DB support to `Tempus` library.

  Start with adding the `tempus_sql` dependency to your project.

  ```elixir
  def deps do
    [
      {:tempus_sql, "~> 0.1"}
    ]
  end
  ```

  Generate a migration to add a custom type to your Postgres DB.

  ```sh
  $ mix tempus.gen.postgres.tempus_slot
  ```

  Create a schema which would use the type.

  ```elixir
  schema "meetings" do
    field :name,  :string
    field :slot,  Tempus.Ecto.Composite.Type
    timestamps()
  end

  def changeset(meeting, params \\ %{}),
    do: cast(meeting, params, [:slot])
  ```

  For custom queries see `Tempus.Ecto.Query.API`.
  """
end
