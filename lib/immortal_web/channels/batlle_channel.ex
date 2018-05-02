defmodule ImmortalWeb.BattleChannel do
  use Phoenix.Channel

  def join("battle:p2p" <> _user_id, _auth_message, socket) do
    {:ok, socket}
    {:reply, :ok, socket}
  end

  def handle_in("action", %{"body" => body}, socket) do
    push socket, "action", %{body: body}
    attack = body.attack
    user_id = 1
    enemy = Repo.get(Immortal.Characters.Character, user_id)
    Ecto.Changeset.change(enemy, %{health: enemy.health - attack}) |> Repo.update!
    {:reply, :ok, socket}
  end
end
