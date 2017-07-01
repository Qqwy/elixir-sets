defmodule SetsTest do
  use ExUnit.Case
  doctest Sets

  for module <- [
        Sets.Implementations.GbSet,
        Sets.Implementations.Ordset,
        Sets.Implementations.UnspecifiedSet,
      ] do

      test "#{module} creation" do
        assert Sets.empty(implementation: unquote(module)) == unquote(module).empty()

        assert :lists.sort(Sets.new([1,2,3], implementation: unquote(module)) |> Sets.to_list) == [1,2,3]
      end

      test "#{module} insertion and to_list" do
        set = Sets.empty(implementation: unquote(module))
        |> Sets.insert(1)
        |> Sets.insert(2)

        assert :lists.sort(Sets.to_list(set)) == [1, 2]
      end

      test "#{module} Extractable.extract" do
        set = simple_set(unquote(module))
        {:ok, {item, set}} = Extractable.extract(set)
        assert item in [1,2,3,4]
        {:ok, {item, set}} = Extractable.extract(set)
        assert item in [1,2,3,4]
        {:ok, {item, set}} = Extractable.extract(set)
        assert item in [1,2,3,4]
        {:ok, {item, set}} = Extractable.extract(set)
        assert item in [1,2,3,4]
        assert {:error, :empty} == Extractable.extract(set)
      end

      test "#{module} delete" do
        set = Sets.empty(implementation: unquote(module)) |> Sets.insert(42)
        assert Sets.delete(set, 42) == Sets.empty(implementation: unquote(module))
      end

      test "#{module} size" do
        set = Sets.empty(implementation: unquote(module))
        assert Sets.size(set) == 0

        set = Sets.empty(implementation: unquote(module)) |> Sets.insert(42)
        assert Sets.size(set) == 1

        set = simple_set(unquote(module))
        assert Sets.size(set) == 4
      end

      test "#{module} member?" do
        set = Sets.empty(implementation: unquote(module))
        assert Sets.member?(set, 42) == false

        set = Sets.empty(implementation: unquote(module)) |> Sets.insert(42)
        assert Sets.member?(set, 42) == true
        assert Sets.member?(set, 1) == false

        set = simple_set(unquote(module))
        assert Sets.member?(set, 4) == true
        assert Sets.member?(set, 3) == true
        assert Sets.member?(set, 2) == true
        assert Sets.member?(set, 1) == true
        assert Sets.member?(set, 42) == false
      end

      test "#{module} Collectable" do
        set = Enum.into(1..100, Sets.empty(implementation: unquote(module)))
        assert :lists.sort(Sets.to_list(set)) == Enum.to_list(1..100)
      end

      test "#{module} difference" do
        set = simple_set(unquote(module))
        assert Sets.equal?(Sets.difference(set, set), Sets.empty(implementation: unquote(module)))
        assert Sets.equal?(Sets.difference(set, Sets.empty(implementation: unquote(module))), set)
      end

      test "#{module} union" do
        set = simple_set(unquote(module))
        assert Sets.equal?(Sets.union(set, Sets.empty(implementation: unquote(module))), set)
        assert Sets.equal?(Sets.union(set, set), set)
      end

      test "#{module} intersection" do
        set = simple_set(unquote(module))
        assert Sets.equal?(Sets.intersection(set, set), set)
        assert Sets.equal?(Sets.intersection(Sets.new([1,2], implementation: unquote(module)), Sets.new([1,3], implementation: unquote(module))), Sets.new([1], implementation: unquote(module)))
      end
  end

  defp simple_set(impl_module) do
    Sets.empty(implementation: impl_module)
    |> Sets.insert(1)
    |> Sets.insert(2)
    |> Sets.insert(3)
    |> Sets.insert(4)
  end

end
