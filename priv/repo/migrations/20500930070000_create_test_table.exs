defmodule Money.Repo.Migrations.CreateMoneyTable do
  use Ecto.Migration

  def change do
    create table(:occasions) do
      add :name,            :string
      add :initial,         :tempus_slot
      add :settled,         :tempus_slot
      add :suggested,       :map
      timestamps()
    end
  end
end
