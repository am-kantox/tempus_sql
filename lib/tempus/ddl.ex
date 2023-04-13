defmodule Tempus.DDL do
  @moduledoc false

  _ = """
  Functions to return SQL DDL commands that support the
    creation and deletion of the `tempus_slot` database type.
  """

  @default_db :postgres

  @supported_db_types :tempus_sql
                      |> :code.priv_dir()
                      |> Path.join("SQL")
                      |> File.ls!()
                      |> Enum.map(&String.to_atom/1)

  @doc """
  Returns the SQL string which when executed will
  define the `tempus_slot` data type.

  ## Arguments

  * `db_type`: the type of the database for which the SQL
    string should be returned.  Defaults to `:postgres` which
    is currently the only supported database type.

  """
  def create_tempus_slot(db_type \\ @default_db) do
    read_sql_file(db_type, "create_tempus_slot.sql")
  end

  @doc """
  Returns the SQL string which when executed will
  drop the `tempus_slot` data type.

  ## Arguments

  * `db_type`: the type of the database for which the SQL
    string should be returned.  Defaults to `:postgres` which
    is currently the only supported database type.

  """
  def drop_tempus_slot(db_type \\ @default_db) do
    read_sql_file(db_type, "drop_tempus_slot.sql")
  end

  @doc """
  Returns a string that will Ecto `execute` each SQL command.

  ## Arguments

  * `sql` is a string of SQL commands that are
    separated by three newlines ("\\n"),
    that is to say two blank lines between commands
    in the file.

  ## Example

      iex> Tempus.DDL.execute "SELECT name FROM customers;\n\n\nSELECT id FROM orders;"
      "execute \"\"\"\nSELECT name FROM customers;\n\n\nSELECT id FROM orders;\n\"\"\""

  """
  def execute_each(sql) do
    sql
    |> String.split("\n\n\n")
    |> Enum.map_join("\n", &execute/1)
  end

  @doc """
  Returns a string that will Ecto `execute` a single SQL command.

  ## Arguments

  * `sql` is a single SQL command

  ## Example

      iex> Tempus.DDL.execute "SELECT name FROM customers;"
      "execute \"SELECT name FROM customers;\""

  """
  def execute(sql) do
    sql = String.trim_trailing(sql, "\n")

    if String.contains?(sql, "\n") do
      "execute \"\"\"\n" <> sql <> "\n\"\"\""
    else
      "execute " <> inspect(sql)
    end
  end

  defp read_sql_file(db_type, file_name) when db_type in @supported_db_types do
    base_dir(db_type)
    |> Path.join(file_name)
    |> File.read!()
  end

  defp read_sql_file(db_type, file_name) do
    raise ArgumentError,
          "Database type #{db_type} does not have a SQL definition " <>
            "file #{inspect(file_name)}"
  end

  @app Mix.Project.config()[:app]
  defp base_dir(db_type) do
    @app
    |> :code.priv_dir()
    |> Path.join(["SQL", "/#{db_type}"])
  end
end
