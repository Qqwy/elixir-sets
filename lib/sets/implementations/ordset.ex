defmodule Sets.Implementations.Ordset do
  alias __MODULE__

  @moduledoc """
  A General Balanced set (built on top of a General Balanced tree).
  This Set implementation is based on the Erlang `:ordsets` module.

  (See http://erlang.org/doc/man/ordsets.html)
  """

  defstruct [:contents]

  use FunLand.Reducable
  def reduce(%Ordset{contents: contents}, acc, fun) do
    :ordsets.fold(fun, acc, contents)
  end

  use FunLand.Combinable
  def empty(), do: %Ordset{contents: :ordsets.new()}
  def combine(set1, set2), do: %Ordset{contents: :ordsets.union(set1, set2)}

  defimpl Sets.Protocol do
    alias Sets.Implementations.Ordset

    def insert(set = %Ordset{contents: contents}, elem) do
      %Ordset{set | contents: :ordsets.add_element(elem, contents)}
    end

    def delete(set = %Ordset{contents: contents}, elem) do
      %Ordset{set | contents: :ordsets.del_element(elem, contents)}
    end

    def size(_set = %Ordset{contents: contents}) do
      :ordsets.size(contents)
    end

    def difference(%Ordset{contents: contents1}, %Ordset{contents: contents2}) do
      %Ordset{contents: :ordsets.subtract(contents1, contents2)}
    end

    def union(%Ordset{contents: contents1}, %Ordset{contents: contents2}) do
      %Ordset{contents: :ordsets.union(contents1, contents2)}
    end

    def intersection(%Ordset{contents: contents1}, %Ordset{contents: contents2}) do
      %Ordset{contents: :ordsets.intersection(contents1, contents2)}
    end

    def member?(%Ordset{contents: contents}, elem) do
      :ordsets.is_element(elem, contents)
    end

    def disjoint?(%Ordset{contents: contents1}, %Ordset{contents: contents2}) do
      :ordsets.is_disjoint(contents1, contents2)
    end

    def equal?(%Ordset{contents: contents1}, %Ordset{contents: contents2}) do
      contents1 == contents2
    end

    def subset?(%Ordset{contents: contents1}, %Ordset{contents: contents2}) do
       :ordsets.is_subset(contents1, contents2)
    end

    def singleton(elem) do
      contents = :ordsets.add_element(elem, :ordsets.new())
      %Ordset{contents: contents}
    end

    def to_list(%Ordset{contents: contents}) do
      :ordsets.to_list(contents)
    end
  end

  defimpl Extractable do
    def extract(set = %Ordset{contents: contents}) do
      # `ordsets` has a publicly defined set shape (a list) and it is allowed to match on it.
        case contents do
          [] -> {:error, :empty}
          [elem | new_contents] ->
            new_set = %Ordset{set | contents: new_contents}
            {:ok, {elem, new_set}}
        end
    end
  end

  defimpl Insertable do
    def insert(set = %Ordset{contents: contents}, elem) do
      new_set = %Ordset{set | contents: :ordsets.add_element(elem, contents)}
      {:ok, new_set}
    end
  end
end
