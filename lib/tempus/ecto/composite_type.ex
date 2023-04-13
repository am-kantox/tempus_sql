if Code.ensure_loaded?(Ecto.Type) do
  defmodule Tempus.Ecto.Composite.Type do
    @moduledoc """
    Implements the Ecto.Type behaviour for a user-defined Postgres composite type
    called `:tempus_slot`.
    """

    use Ecto.ParameterizedType

    alias Tempus.Slot
    import Tempus.Guards, only: [is_slot_equal: 2]

    @impl Ecto.ParameterizedType
    def type(_params), do: :tempus_slot

    def cast_type(opts \\ []), do: Ecto.ParameterizedType.init(__MODULE__, opts)

    @impl Ecto.ParameterizedType
    def init(opts), do: Keyword.drop(opts, ~w|field schema default|a)

    @impl Ecto.ParameterizedType
    def load(tuple, loader \\ nil, params \\ [])

    def load(nil, _loader, _params), do: {:ok, nil}

    def load({from, to}, _loader, _params), do: {:ok, Slot.new(from, to)}

    # Dumping to the database.  We make the assumption that
    # since we are dumping from %Slot{} structs that the
    # data is ok

    @impl Ecto.ParameterizedType
    def dump(slot, dumper \\ nil, params \\ [])

    def dump(nil, _, _), do: {:ok, nil}
    def dump(%Slot{from: nil, to: nil}, _dumper, _params), do: {:ok, nil}
    def dump(%Slot{from: from, to: to}, _dumper, _params), do: {:ok, {from, to}}
    def dump(_, _, _), do: :error

    # Casting in changesets

    def cast(slot), do: cast(slot, [])

    @impl Ecto.ParameterizedType
    def cast(nil, _params), do: {:ok, nil}
    def cast(%Slot{from: nil, to: nil}, _params), do: {:ok, nil}
    def cast(%Slot{} = slot, _params), do: {:ok, slot}

    def cast(%{"from" => from, "to" => to}, _params) when is_binary(from) and is_binary(to),
      do: Tempus.guess(from, to)

    def cast(%{"from" => from, "to" => to}, params) when is_binary(from) do
      with {:ok, slot} <- Tempus.guess(from),
           do: cast(%{"from" => slot.from, "to" => to}, params)
    end

    def cast(%{"from" => from, "to" => to}, params) when is_binary(to) do
      with {:ok, slot} <- Tempus.guess(to),
           do: cast(%{"from" => from, "to" => slot.to}, params)
    end

    def cast(%{"from" => from, "to" => to}, _params)
        when (is_struct(from, DateTime) or is_nil(from)) and
               (is_struct(to, DateTime) or is_nil(to)),
        do: Tempus.slot(from, to)

    def cast(%{} = malformed, _params) do
      {:error,
       exception: Tempus.ArgumentError,
       message: "Cannot cast ‹#{inspect(malformed)}› to `Tempus.Slot`"}
    end

    def cast(%{from: from, to: to}, params), do: cast(%{"from" => from, "to" => to}, params)

    def cast(string, _params) when is_binary(string) do
      case Tempus.Sigils.parse(string) do
        {:error, reason} -> {:error, exception: Tempus.ArgumentError, message: inspect(reason)}
        {:ok, %Slot{} = slot} -> {:ok, slot}
      end
    end

    def cast(_slot, _params), do: :error

    def embed_as(term), do: embed_as(term, [])

    @impl Ecto.ParameterizedType
    def embed_as(_term, _params), do: :self

    def equal?(s1, s2), do: equal?(s1, s2, [])

    @impl Ecto.ParameterizedType
    def equal?(s1, s2, _params) when is_slot_equal(s1, s2), do: true
    def equal?(_s1, _s2, _params), do: false
  end
end
