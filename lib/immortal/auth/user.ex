defmodule Immortal.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Immortal.Auth.User
  alias Comeonin.Bcrypt
  alias Immortal.Characters.Character

  schema "users" do
    field :password, :string
    field :username, :string
    has_many :characters, Immortal.Characters.Character

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end
  defp put_pass_hash(changeset), do: changeset
end
