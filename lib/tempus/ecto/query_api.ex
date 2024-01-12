if Code.ensure_loaded?(Ecto.Query.API) do
  defmodule Tempus.Ecto.Query.API do
    @moduledoc """
    Provides several helpers to query DB for the `Tempus.Slot` type.

    Under the hood it delegates to
    [`Ecto.Query.API.fragment/1`](https://hexdocs.pm/ecto/Ecto.Query.API.html#fragment/1-defining-custom-functions-using-macros-and-fragment),
    but might be helpful for compile-type sanity check for typos and
    better language server support.

    It is also designed to be an implementation-agnostic, meaning one can use
    these helpers without a necessity to explicitly specify a backing type.

    The default implementation recommends a `Composite` adapter, which is used by default.
    To use it with, say, `MySQL`, one should implement this behaviour for `MySQL` and declare
    the implementation as `use Tempus.Ecto.Query.API, adapter: MyImpl.MySQL.Adapter`

    Although the library provides the MySQL adapter too (`Tempus.Ecto.Query.API.Map.MySQL`,)
    but it is not actively maintained, so use it on your own.

    If for some reason you use `Map` type with `Postgres`, helpers are still available
    with `use Tempus.Ecto.Query.API, adapter: Tempus.Ecto.Query.API.Map.Postgres`
    """

    @doc """
    Native implementation of how to retrieve `from` part of the slot from the DB.

    For `Postgres`, it delegates to the function on the composite type,
      for other implementation it should return a `Ecto.Query.API.fragment/1`.
    """
    @macrocallback slot_from(Macro.t()) :: Macro.t()

    @doc """
    Native implementation of how to retrieve `to` part of the slot from the DB.

    For `Postgres`, it delegates to the function on the composite type,
      for other implementation it should return a `Ecto.Query.API.fragment/1`.
    """
    @macrocallback slot_to(Macro.t()) :: Macro.t()

    @doc false
    defmacro __using__(opts \\ [])

    defmacro __using__([]),
      do: do_using(Tempus.Ecto.Query.API.Composite)

    @doc false
    defmacro __using__(adapter: adapter),
      do: do_using(adapter)

    defp do_using(adapter) do
      quote do
        import unquote(adapter)
        import Tempus.Ecto.Query.API
      end
    end

    @doc """
    `Ecto.Query.API` helper, allowing to filter records having the same currency.

    _Example:_

    ```elixir
    dt = ~U[2023-01-01 00:00:00Z]
    Occasion
    |> where([o], started_after(o.initial, ^dt))
    |> select([o], o.initial)
    |> Repo.all()
    #⇒ [%Tempus.Slot{from: ~U[2023-04-07 00:00:00Z], to: ~U[2023-04-10 23:59:59.999999Z]}]
    ```
    """
    defmacro started_after(field, dt) do
      quote do: slot_from(unquote(field)) > ^unquote(dt)
    end
  end
end
