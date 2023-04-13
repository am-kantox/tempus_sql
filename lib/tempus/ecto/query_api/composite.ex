if Code.ensure_loaded?(Ecto.Query.API) do
  defmodule Money.Ecto.Query.API.Composite do
    @moduledoc false

    @behaviour Money.Ecto.Query.API

    defmacro slot_from(field),
      do: quote(do: fragment("slot_from(?)", unquote(field)))

    defmacro slot_to(field),
      do: quote(do: fragment("slot_to(?)", unquote(field)))
  end
end
