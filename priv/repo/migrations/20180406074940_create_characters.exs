defmodule Immortal.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :name, :string
      add :health, :integer
      add :attack, :integer

      timestamps()
    end

  end
end
