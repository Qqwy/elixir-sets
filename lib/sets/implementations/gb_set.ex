defmodule Sets.Implementations.GbSet do
  alias __MODULE__
  @behaviour Sets.Behaviour

  @moduledoc """
  A General Balanced set (built on top of a General Balanced tree).
  This Set implementation is based on the Erlang `:gb_sets` module.

  (See http://erlang.org/doc/man/gb_sets.html)
  """

  defstruct [:contents]

  use FunLand.Reducable
  def reduce(%GbSet{contents: contents}, acc, fun) do
    :gb_sets.fold(fun, acc, contents)
  end

  use FunLand.Combinable
  def empty(), do: %GbSet{contents: :gb_sets.empty()}
  def empty(options) do
    if options != [] do
      IO.puts "Warning: GbSet.empty/1 does not understand options: #{inspect(options)}"
    end
    %GbSet{contents: :gb_sets.empty()}
  end

  def combine(set1, set2), do: %GbSet{contents: :gb_sets.union(set1, set2)}

  defimpl Sets.Protocol do
    alias Sets.Implementations.GbSet

    def insert(set = %GbSet{contents: contents}, elem) do
      %GbSet{set | contents: :gb_sets.add_element(elem, contents)}
    end

    def delete(set = %GbSet{contents: contents}, elem) do
      %GbSet{set | contents: :gb_sets.del_element(elem, contents)}
    end

    def size(_set = %GbSet{contents: contents}) do
      :gb_sets.size(contents)
    end

    def difference(%GbSet{contents: contents1}, %GbSet{contents: contents2}) do
      %GbSet{contents: :gb_sets.subtract(contents1, contents2)}
    end

    def union(%GbSet{contents: contents1}, %GbSet{contents: contents2}) do
      %GbSet{contents: :gb_sets.union(contents1, contents2)}
    end

    def intersection(%GbSet{contents: contents1}, %GbSet{contents: contents2}) do
      %GbSet{contents: :gb_sets.intersection(contents1, contents2)}
    end

    def member?(%GbSet{contents: contents}, elem) do
      :gb_sets.is_element(elem, contents)
    end

    def disjoint?(%GbSet{contents: contents1}, %GbSet{contents: contents2}) do
      :gb_sets.is_disjoint(contents1, contents2)
    end

    # Quite slow...
    def equal?(%GbSet{contents: contents1}, %GbSet{contents: contents2}) do
      :gb_sets.balance(contents1) == :gb_sets.balance(contents2)
    end

    def subset?(%GbSet{contents: contents1}, %GbSet{contents: contents2}) do
       :gb_sets.is_subset(contents1, contents2)
    end

    def singleton(elem) do
      %GbSet{contents: :gb_sets.singleton(elem)}
    end

    def to_list(%GbSet{contents: contents}) do
      :gb_sets.to_list(contents)
    end
  end

  defimpl Extractable do
    def extract(set = %GbSet{contents: contents}) do
      if :gb_sets.is_empty(contents) do
        {:error, :empty}
      else
        {elem, new_contents} = :gb_sets.take_smallest(contents)
        new_set = %GbSet{set | contents: new_contents}
        {:ok, {elem, new_set}}
      end
    end
  end

  defimpl Insertable do
    def insert(set = %GbSet{contents: contents}, elem) do
      new_set = %GbSet{set | contents: :gb_sets.add_element(elem, contents)}
      {:ok, new_set}
    end
  end
end
