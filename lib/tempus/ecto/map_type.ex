if Code.ensure_loaded?(Ecto.Type) do
  defmodule Tempus.Ecto.Map.Type do
    @moduledoc """
    Implements `Ecto.Type` behaviour for `Tempus.Slot`,
      where the underlying schema type is a map.

    This is the required option for databases such as _MySQL_
      that do not support composite types.
    """

    use Ecto.ParameterizedType

    defdelegate init(params), to: Tempus.Ecto.Composite.Type
    defdelegate cast(slot), to: Tempus.Ecto.Composite.Type
    defdelegate cast(slot, params), to: Tempus.Ecto.Composite.Type

    # New for ecto_sql 3.2
    defdelegate embed_as(term), to: Tempus.Ecto.Composite.Type
    defdelegate embed_as(term, params), to: Tempus.Ecto.Composite.Type
    defdelegate equal?(term1, term2), to: Tempus.Ecto.Composite.Type
    defdelegate equal?(term1, term2, params), to: Tempus.Ecto.Composite.Type

    def type(_params), do: :map

    def load(slot, loader \\ nil, params \\ [])
    def load(nil, _loader, _params), do: {:ok, nil}

    def load(%{"slot_from" => from, "slot_to" => to}, _loader, _params)
        when (is_struct(from, DateTime) or is_nil(from)) and
               (is_struct(to, DateTime) or is_nil(to)),
        do: Tempus.slot(from, to)

    def load(%{"slot_from" => from, "slot_to" => to}, _loader, _params)
        when is_binary(from) and is_binary(to),
        do: Tempus.guess(from, to)

    def dump(slot, dumper \\ nil, params \\ [])

    def dump(%Tempus.Slot{from: from, to: to}, _dumper, _params),
      do: {:ok, %{"slot_from" => from, "slot_to" => to}}

    def dump(nil, _, _), do: {:ok, nil}
    def dump(_, _, _), do: :error
  end
end
