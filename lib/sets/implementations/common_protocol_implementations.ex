for module <- [
      Sets.Implementations.GbSet,
      Sets.Implementations.UnspecifiedSet,
    ] do

    defimpl Inspect, for: module do
      import Inspect.Algebra

      def inspect(set, _opts) do
        concat ["##{inspect(@for)}<", inspect(Sets.Protocol.to_list(set)) ,">"]
      end
    end

    defimpl Enumerable, for: module do
      def reduce(_, {:halt, acc}, _fun), do: {:halted, acc}
      def reduce(set, {:suspend, acc}, fun), do: {:suspended, acc, &reduce(set, &1, fun)}
      def reduce(set, {:cont, acc}, fun) do
        case Extractable.extract(set) do
          {:error, :empty} ->
            acc
          {:ok, {elem, set_rest}} ->
            reduce(set_rest, fun.(elem, acc), acc)
        end
      end

      def member?(set, elem) do
        {:ok, Sets.Protocol.member?(set, elem)}
      end

      def count(set) do
        {:ok, Sets.Protocol.size(set)}
      end
    end

    defimpl Collectable, for: module do
      def into(original) do
        collector_fun = fn
          set, {:cont, elem} ->
            Sets.Protocol.insert(set, elem)
          set, :done -> set
          _set, :halt -> :ok
        end

        {original, collector_fun}
      end
    end
end
