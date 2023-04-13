defmodule Occasion do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "occasions" do
    field :name,            :string
    field :initial,         Tempus.Ecto.Composite.Type
    field :settled,         Tempus.Ecto.Composite.Type
    field :suggested,       Tempus.Ecto.Map.Type
    timestamps()
  end

  def changeset(occasion, params \\ %{}),
    do: cast(occasion, params, [:initial, :settled, :suggested])
end
