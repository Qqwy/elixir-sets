# MapSet is Elixir's built-in Set datatype built on top of a Map.

defimpl Sets.Protocol, for: MapSet do
  @doc """
  Inserts `elem` into `set`.
  If an equal `elem` was already in `set`,
  this value is not replaced.
  """

  def insert(set, elem) do
    MapSet.put(set, elem)
  end

  @doc """
  Deletes `elem` from `set`,
  doing nothing if the set does not contain `elem`
  """

  def delete(set, elem) do
    MapSet.delete(set, elem)
  end

  @doc """
  Returns the amount of elems in the `set`.
  """

  def size(set), do: MapSet.size(set)

  @doc """
  Returns a set containing all elements of `set1`
  that are not also in `set2`.
  """

  def difference(set1, set2) do
    MapSet.delete(set1, set2)
  end

  @doc """
  Returns the combination of elements of `set1` and `set2`.
  """

  def union(set1, set2) do
    MapSet.union(set1, set2)
  end

  @doc """
  Returns a set containing only the elements both in `set1` and `set2`.
  """

  def intersection(set1, set2) do
    MapSet.intersection(set1, set2)
  end

  @doc """
  True if `elem` is contained in `set`.
  """

  def member?(set, elem) do
    MapSet.member?(set, elem)
  end

  @doc """
  True if `set1` and `set2` have no members in common.
  """

  def disjoint?(set1, set2) do
    MapSet.disjoint?(set1, set2)
  end

  @doc """
  True if `set1` and `set2` contain exactly the same elements.
  """

  def equal?(set1, set2) do
    MapSet.equal?(set1, set2)
  end

  @doc """
  True if `set1` is a subset of `set2`,
  which means that all members of `set1` are contained in `set2`.
  """

  def subset?(set1, set2) do
    MapSet.subset?(set1, set2)
  end

  @doc """
  Creates a set containing the single element `elem`.
  """

  def singleton(elem) do
    MapSet.new([elem])
  end

  @doc """
  Converts the set to a list (in any order)
  """

  def to_list(set) do
    MapSet.to_list(set)
  end
end
