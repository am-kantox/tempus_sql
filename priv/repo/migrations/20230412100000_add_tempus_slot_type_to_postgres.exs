defmodule Tempus.SQL.Repo.Migrations.AddTempusSlotTypeToPostgres do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE public.tempus_slot AS (slot_from timestamp with time zone, slot_to timestamp with time zone);")
  end

  def down do
    execute("DROP TYPE public.tempus_slot;")
  end
end
