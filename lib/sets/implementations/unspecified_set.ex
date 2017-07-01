defmodule Sets.Implementations.UnspecifiedSet do
  alias __MODULE__
  @behaviour Sets.Behaviour

  @moduledoc """
  A Set with an unspecified storage mechanism.
  This Set implementation is based on the Erlang `:sets` module.

  (See http://erlang.org/doc/man/sets.html)
  """

  defstruct [:contents]

  use FunLand.Reducable
  def reduce(%UnspecifiedSet{contents: contents}, acc, fun) do
    :sets.fold(fun, acc, contents)
  end

  use FunLand.Combinable
  def empty(), do: %UnspecifiedSet{contents: :sets.new()}
  def empty(options) do
    if options != [] do
      IO.puts "Warning: GbSet.empty/1 does not understand options: #{inspect(options)}"
    end
    %UnspecifiedSet{contents: :sets.new()}
  end

  def combine(set1, set2), do: %UnspecifiedSet{contents: :sets.union(set1, set2)}

  defimpl Sets.Protocol do
    alias Sets.Implementations.UnspecifiedSet

    def insert(set = %UnspecifiedSet{contents: contents}, elem) do
      %UnspecifiedSet{set | contents: :sets.add_element(elem, contents)}
    end

    def delete(set = %UnspecifiedSet{contents: contents}, elem) do
      %UnspecifiedSet{set | contents: :sets.del_element(elem, contents)}
    end

    def size(_set = %UnspecifiedSet{contents: contents}) do
      :sets.size(contents)
    end

    def difference(%UnspecifiedSet{contents: contents1}, %UnspecifiedSet{contents: contents2}) do
      %UnspecifiedSet{contents: :sets.subtract(contents1, contents2)}
    end

    def union(%UnspecifiedSet{contents: contents1}, %UnspecifiedSet{contents: contents2}) do
      %UnspecifiedSet{contents: :sets.union(contents1, contents2)}
    end

    def intersection(%UnspecifiedSet{contents: contents1}, %UnspecifiedSet{contents: contents2}) do
      %UnspecifiedSet{contents: :sets.intersection(contents1, contents2)}
    end

    def member?(%UnspecifiedSet{contents: contents}, elem) do
      :sets.is_element(elem, contents)
    end

    def disjoint?(%UnspecifiedSet{contents: contents1}, %UnspecifiedSet{contents: contents2}) do
      :sets.is_disjoint(contents1, contents2)
    end

    # Quite slow...
    def equal?(%UnspecifiedSet{contents: contents1}, %UnspecifiedSet{contents: contents2}) do
      :sets.to_list(contents1) == :sets.to_list(contents2)
    end

    def subset?(%UnspecifiedSet{contents: contents1}, %UnspecifiedSet{contents: contents2}) do
       :sets.is_subset(contents1, contents2)
    end

    def singleton(elem) do
      contents = :sets.add_element(elem, :sets.new())
      %UnspecifiedSet{contents: contents}
    end

    def to_list(%UnspecifiedSet{contents: contents}) do
      :sets.to_list(contents)
    end
  end

  defimpl Extractable do
    def extract(set = %UnspecifiedSet{contents: contents}) do
      set_as_list = :sets.to_list(contents)
      case set_as_list do
        [] -> {:error, :empty}
        [elem | rest] ->
          new_contents = :sets.from_list(rest)
          new_set = %UnspecifiedSet{set | contents: new_contents}
          {:ok, {elem, new_set}}
      end
    end
  end

  defimpl Insertable do
    def insert(set = %UnspecifiedSet{contents: contents}, elem) do
      new_set = %UnspecifiedSet{set | contents: :sets.add_element(elem, contents)}
      {:ok, new_set}
    end
  end
end
