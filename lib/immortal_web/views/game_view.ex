defmodule ImmortalWeb.GameView do
  use ImmortalWeb, :view

  def render("scripts.html", _assigns) do
    ~s{<script>
      require("js/chat").Chat.run()
      require("js/game").Game.run()
    </script>}
    |> raw
  end

end
