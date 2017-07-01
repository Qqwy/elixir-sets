defmodule Sets do
  @moduledoc """
  Well-structured Sets for Elixir, offering a common interface with multiple implementations with varying performance guarantees that can be switched in your configuration.

  By default, `Sets` ships with:

  - `Sets.Implementations.GbSet`: A Set representation built on top of a Generalized Balanced Binary Tree. Wraps the Erlang `:gb_sets` library.
  - `Sets.Implementations.Ordset`: A Set representation built on top of an ordered list. Wraps the Erlang `:ordsets` library.
  - `Sets.Implementations.UnspecifiedSet`: A set representation whose internals are unspecified (and might change in future Erlang versions). Wraps the Erlang `:sets` library.
  - `MapSet`: The Elixir set type that is part of Elixir's core library, built on top of the built-in hashmap type.

  ### Protocols and behaviours

  All sets that are part of `Sets` implement the following protocols:

  - `Sets.Protocol` (implementing this for a different datatype allows you to use 99% of the functions of `Sets` directly on that datatype)
  - `Enumerable`: Elixir's built-in folding protocol.
  - `Collectable`: Elixir's built-in collecting protocol.
  - `FunLand.Combinable`: FunLand's combining semi-protocol.
  - `FunLand.Reducable`: FunLand's simplified folding semi-protocol.
  - `Extractable`: Extractable's protocol extracting one element at a time.
  - `Insertable`: Insertable's protocol to insert one element at a time.
  - `Inspect`: A humanly readable visual representation of the set, regardless of the inner structual representation.

  ### Creating your own Sets implementation:

  If you want to create your own Sets implementation, create a module+struct that at least:

  - Implements the Sets.Behaviour (`@behaviour Sets.Behaviour`).
  - Implements the Sets.Protocol protocol.

  Implementing the other protocols and behaviours listed in the Protocols section is very helpful as well,
  as it is possible that certain other libraries expect a set implementation to work with them.

  ## Examples

      iex> Sets.new([1,2,3,4])
      #Sets.Implementations.GbSet<[1, 2, 3, 4]>

      iex> Sets.new([1,2,3,4], implementation: Sets.Implementations.Ordset)
      #Sets.Implementations.Ordset<[1, 2, 3, 4]>

      iex> Sets.new([1,2,3,4], implementation: MapSet)
      #MapSet<[1, 2, 3, 4]>

      iex> Sets.union(Sets.new([1,2]), Sets.new([1]))
      #Sets.Implementations.GbSet<[1, 2]>

  """

  @type set :: Sets.Protocol.t

  @default_set_implementation  Sets.Implementations.GbSet
  @doc """
  Creates a new, empty set.

  Pass `:implementation` with a module name to use a different set implementation.
  This can also be overridden by specifying, in your configuration file:

  ```
  config :sets, default_set_implementation: YourSetImplementationModule
  ```

  By default, #{inspect(@default_set_implementation)} is used.
  """
  def empty(options \\ []) do
    impl_module = Keyword.get(options, :implementation, Application.get_env(:sets, :default_set_implementation, @default_set_implementation))

    case impl_module do
      MapSet ->
        if Keyword.delete(options, :implementation) != [] do
          IO.puts "Warning: `Sets.empty()` called for implementation `MapSet`, but it does not know these options: #{inspect(options)}"
        end
        MapSet.new()
      _ ->
        options = Keyword.delete(options, :implementation)
        impl_module.empty(options)
    end
  end

  @doc """
  Creates a new set based on the values in `enumerable`.
  Takes the same `options` as second argument as `empty` does:

  - Pass `:implementation` with a module name to use a different set implementation.
    By default, #{inspect(@default_set_implementation)} is used.

  - Other options are passed on to the underlying set implementation.
  """
  def new(enumerable, options \\ []) do
    Enum.into(enumerable, empty(options))
  end

  @doc """
  Inserts `elem` into `set`.
  If an equal `elem` was already in `set`,
  this value is not replaced.
  """
  @spec insert(set, elem :: any) :: set
  defdelegate insert(set, elem), to: Sets.Protocol

  @doc """
  Deletes `elem` from `set`,
  doing nothing if the set does not contain `elem`
  """
  @spec delete(set, elem :: any) :: set
  defdelegate delete(set, elem), to: Sets.Protocol

  @doc """
  Returns the amount of elems in the `set`.
  """
  @spec size(set) :: non_neg_integer
  defdelegate size(set), to: Sets.Protocol

  @doc """
  Returns a set containing all elements of `set1`
  that are not also in `set2`.
  """
  @spec difference(set, set) :: set
  defdelegate difference(set1, set2), to: Sets.Protocol

  @doc """
  Returns the combination of elements of `set1` and `set2`.
  """
  @spec union(set, set) :: set
  defdelegate union(set1, set2), to: Sets.Protocol

  @doc """
  Returns a set containing only the elements both in `set1` and `set2`.
  """
  @spec intersection(set, set) :: set
  defdelegate intersection(set1, set2), to: Sets.Protocol

  @doc """
  True if `elem` is contained in `set`.
  """
  @spec member?(set, elem :: any) :: boolean
  defdelegate member?(set, elem), to: Sets.Protocol

  @doc """
  True if `set1` and `set2` have no members in common.
  """
  @spec disjoint?(set, set) :: boolean
  defdelegate disjoint?(set, set), to: Sets.Protocol

  @doc """
  True if `set1` and `set2` contain exactly the same elements.
  """
  @spec equal?(set, set) :: boolean
  defdelegate equal?(set1, set2), to: Sets.Protocol

  @doc """
  True if `set1` is a subset of `set2`,
  which means that all members of `set1` are contained in `set2`.
  """
  @spec subset?(set, set) :: boolean
  defdelegate subset?(set1, set2), to: Sets.Protocol

  @doc """
  Creates a set containing the single element `elem`.
  """
  @spec singleton(elem :: any) :: set
  defdelegate singleton(elem), to: Sets.Protocol

  @doc """
  Converts the set to a list (in any order)
  """
  @spec to_list(set) :: list
  defdelegate to_list(set), to: Sets.Protocol
end
