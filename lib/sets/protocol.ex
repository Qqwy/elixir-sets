defprotocol Sets.Protocol do
  @type set :: t

  @doc """
  Inserts `elem` into `set`.
  If an equal `elem` was already in `set`,
  this value is not replaced.
  """
  @spec insert(set, elem :: any) :: set
  def insert(set, elem)

  @doc """
  Deletes `elem` from `set`,
  doing nothing if the set does not contain `elem`
  """
  @spec delete(set, elem :: any) :: set
  def delete(set, elem)

  @doc """
  Returns the amount of elems in the `set`.
  """
  @spec size(set) :: non_neg_integer
  def size(set)

  @doc """
  Returns a set containing all elements of `set1`
  that are not also in `set2`.
  """
  @spec difference(set, set) :: set
  def difference(set1, set2)

  @doc """
  Returns the combination of elements of `set1` and `set2`.
  """
  @spec union(set, set) :: set
  def union(set1, set2)

  @doc """
  Returns a set containing only the elements both in `set1` and `set2`.
  """
  @spec intersection(set, set) :: set
  def intersection(set1, set2)

  @doc """
  True if `elem` is contained in `set`.
  """
  @spec member?(set, elem :: any) :: boolean
  def member?(set, elem)

  @doc """
  True if `set1` and `set2` have no members in common.
  """
  @spec disjoint?(set, set) :: boolean
  def disjoint?(set, set)

  @doc """
  True if `set1` and `set2` contain exactly the same elements.
  """
  @spec equal?(set, set) :: boolean
  def equal?(set1, set2)

  @doc """
  True if `set1` is a subset of `set2`,
  which means that all members of `set1` are contained in `set2`.
  """
  @spec subset?(set, set) :: boolean
  def subset?(set1, set2)

  @doc """
  Creates a set containing the single element `elem`.
  """
  @spec singleton(elem :: any) :: set
  def singleton(elem)

  @doc """
  Converts the set to a list (in any order)
  """
  @spec to_list(set) :: list
  def to_list(set)
end
