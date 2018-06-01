defmodule Immortal.CurrentCharacters do
  def init do
    :ets.new(:characters, [:named_table, :public])
  end

  def find(id) do
    :ets.lookup_element(:characters, id, 2)
  end

  def get() do
    list = :ets.tab2list(:characters)
    Enum.map(list, fn(x) -> elem(x, 1) end)
  end

  def put(character) do
    :ets.insert(:characters, {character.id, character})
  end

  def delete(id) do
    :ets.delete(:characters, id)
  end
end
