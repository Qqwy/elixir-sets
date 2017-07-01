defmodule Sets do

  @type set :: t

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
    impl_module.empty()
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
  defdelegate to_list(set)
end
