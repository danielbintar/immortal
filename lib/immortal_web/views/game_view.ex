defmodule ImmortalWeb.GameView do
  use ImmortalWeb, :view

  def render("scripts.html", _assigns) do
    ~s{<script>require("js/chat").Chat.run()</script>}
    |> raw
  end

end
