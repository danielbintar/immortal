defmodule Immortal.Maps do

  def init do
    create()
    Enum.each(0..79, fn(x) ->
      Enum.each(0..79, fn(y) ->
        set_value(x, y, 0)
      end)
    end)
  end

  defp create do
    :ets.new(:map_character_position, [:named_table, :public])
  end

  def set_value(x, y, value) do
    :ets.insert(:map_character_position, {{x, y}, value})
  end

  def value(x, y) do
    h = :ets.lookup(:map_character_position, {x, y})
    elem(Enum.at(h, 0), 1)
  end
end
