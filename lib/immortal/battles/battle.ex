defmodule Immortal.Battles.Battle do
  use Ecto.Schema
  import Ecto.Changeset


  schema "characters" do
    field :player1,  :integer
    field :player2,  :integer

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:player1, :player2])
    |> validate_required([:player1, :player2])
  end
end
