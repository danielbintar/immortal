defmodule ImmortalWeb.BattleView do
  use ImmortalWeb, :view

  def render("scripts.html", _assigns) do
    ~s{<script>require("js/battle").Battle.run()</script>}
    |> raw
  end

end
