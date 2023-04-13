if Code.ensure_loaded?(Ecto.Query.API) do
  defmodule Tempus.Ecto.Query.API.Map.MySQL do
    @moduledoc false

    @behaviour Tempus.Ecto.Query.API

    @impl Tempus.Ecto.Query.API
    defmacro slot_from(field),
      do: quote(do: fragment(~S|CAST(JSON_EXTRACT(?, "$.from") AS DATETIME)|, unquote(field)))

    @impl Tempus.Ecto.Query.API
    defmacro slot_to(field),
      do: quote(do: fragment(~S|JSON_EXTRACT(?, "$.to")|, unquote(field)))
  end
end
