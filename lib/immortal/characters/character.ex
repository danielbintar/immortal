defmodule Immortal.Characters.Character do
  use Ecto.Schema
  import Ecto.Changeset


  schema "characters" do
    field :attack, :integer
    field :health, :integer
    field :name, :string
    belongs_to :author, User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :health, :attack])
    |> validate_required([:name, :health, :attack])
  end
end
