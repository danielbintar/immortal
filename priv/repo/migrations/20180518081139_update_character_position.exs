defmodule Immortal.Repo.Migrations.UpdateCharacterAssociation do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :position_x, :integer
      add :position_y, :integer
    end
  end
end
