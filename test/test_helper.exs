ExUnit.start()

{:ok, _pid} = Tempus.SQL.Repo.start_link()
:ok = Ecto.Adapters.SQL.Sandbox.mode(Tempus.SQL.Repo, :manual)

defmodule Tempus.SQL.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Tempus.SQL.Repo

      import Ecto
      import Ecto.Query
      import Tempus.SQL.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Tempus.SQL.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Tempus.SQL.Repo, {:shared, self()})
    end

    :ok
  end
end
