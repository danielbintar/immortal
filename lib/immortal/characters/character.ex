defmodule Immortal.Characters.Character do
  use Ecto.Schema
  import Ecto.Changeset


  schema "characters" do
    field :attack,  :integer, default: 5
    field :health,  :integer, default: 20
    field :name,    :string
    belongs_to :author, User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :health, :attack, :user_id])
    |> validate_required([:name, :health, :attack, :user_id])
  end
end
