if Code.ensure_loaded?(Ecto.Query.API) do
  defmodule Tempus.Ecto.Query.API.Map.Postgres do
    @moduledoc false

    @behaviour Tempus.Ecto.Query.API

    @impl Tempus.Ecto.Query.API
    defmacro slot_from(field),
      do: quote(do: fragment(~S|(?->>'slot_from')::timestamptz|, unquote(field)))

    @impl Tempus.Ecto.Query.API
    defmacro slot_to(field),
      do: quote(do: fragment(~S|(?->>'slot_to')::timestamptz|, unquote(field)))
  end
end
