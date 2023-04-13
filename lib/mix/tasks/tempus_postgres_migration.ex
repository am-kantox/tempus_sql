if Code.ensure_loaded?(Ecto) do
  defmodule Mix.Tasks.Tempus.Gen.Postgres.TempusSlot do
    use Mix.Task

    import Macro, only: [camelize: 1, underscore: 1]
    import Mix.Generator
    import Mix.Ecto, except: [migrations_path: 1]
    import Tempus.Slot.Migration

    @shortdoc "Generates a migration to create the :tempus_slot type for Postgres"

    @moduledoc """
    Generates a migration to add a composite type called `:tempus_slot`
      to a Postgres database.

    The `:tempus_slot` type created is a composite type and therefore
      may not be supported in other databases.
    """

    @doc false
    @dialyzer {:no_return, run: 1}

    def run(args) do
      no_umbrella!("tempus.gen.postgres.tempus_slot")
      repos = parse_repo(args)
      name = "add_tempus_slot_type_to_postgres"

      Enum.each(repos, fn repo ->
        ensure_repo(repo, args)
        path = Path.relative_to(migrations_path(repo), Mix.Project.app_path())
        file = Path.join(path, "#{timestamp()}_#{underscore(name)}.exs")
        create_directory(path)

        assigns = [mod: Module.concat([repo, Migrations, camelize(name)])]

        content =
          assigns
          |> migration_template
          |> format_string!

        create_file(file, content)

        if open?(file) and Mix.shell().yes?("Do you want to run this migration?") do
          Mix.Task.run("ecto.migrate", [repo])
        end
      end)
    end

    defp timestamp do
      {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
      "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
    end

    defp pad(i) when i < 10, do: <<?0, ?0 + i>>
    defp pad(i), do: to_string(i)

    embed_template(:migration, """
    defmodule <%= inspect @mod %> do
      use Ecto.Migration

      def up do
        <%= Tempus.DDL.execute(Tempus.DDL.create_tempus_slot()) %>
      end

      def down do
        <%= Tempus.DDL.execute(Tempus.DDL.drop_tempus_slot()) %>
      end
    end
    """)
  end
end
