if Code.ensure_loaded?(Ecto.Query.API) do
  defmodule Tempus.Ecto.Query.API.Map.MySQL do
    @moduledoc false

    @behaviour Tempus.Ecto.Query.API

    @impl Tempus.Ecto.Query.API
    defmacro slot_from(field) do
      quote do
        fragment(
          ~S|CAST(JSON_EXTRACT(?, "$.slot_from") AT TIME ZONE 'UTC' AS DATETIME)|,
          unquote(field)
        )
      end
    end

    @impl Tempus.Ecto.Query.API
    defmacro slot_to(field) do
      quote do
        fragment(
          ~S|CAST(JSON_EXTRACT(?, "$.slot_to") AT TIME ZONE 'UTC' AS DATETIME)|,
          unquote(field)
        )
      end
    end
  end
end
