# Sets
[![hex.pm version](https://img.shields.io/hexpm/v/sets.svg)](https://hex.pm/packages/sets)
[![Build Status](https://travis-ci.org/Qqwy/elixir-sets.svg?branch=master)](https://travis-ci.org/Qqwy/elixir-sets)


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
- `Combinable`: FunLand's combining semi-protocol.
- `Reducable`: FunLand's simplified folding semi-protocol.
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

```elixir
    iex> Sets.new([1,2,3,4])
    #Sets.Implementations.GbSet<[1, 2, 3, 4]>

    iex> Sets.new([1,2,3,4], implementation: Sets.Implementations.Ordset)
    #Sets.Implementations.Ordset<[1, 2, 3, 4]>

    iex> Sets.new([1,2,3,4], implementation: MapSet)
    #MapSet<[1, 2, 3, 4]>

    iex> Sets.union(Sets.new([1,2]), Sets.new([1]))
    #Sets.Implementations.GbSet<[1, 2]>
```

## Installation

The package can be installed
by adding `sets` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sets, "~> 0.1.0"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/sets](https://hexdocs.pm/sets).

