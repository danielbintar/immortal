defmodule Immortal.Repo.Migrations.UpdateCharacterAssociation do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :user_id, references(:users)
    end
  end
end
