# SignedOverpunch

Module for converting a string in signed overpunch format into the
corresponding integer.

## Conversion Table:

| Code | Digit | Sign |
| ---- | ----- | ---- |
| } | 0 | − |
| J | 1 | − |
| K | 2 | − |
| L | 3 | − |
| M | 4 | − |
| N | 5 | − |
| O | 6 | − |
| P | 7 | − |
| Q | 8 | − |
| R | 9 | − |
| { | 0 | + |
| A | 1 | + |
| B | 2 | + |
| C | 3 | + |
| D | 4 | + |
| E | 5 | + |
| F | 6 | + |
| G | 7 | + |
| H | 8 | + |
| I | 9 | + |

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `signed_overpunch` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:signed_overpunch, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/signed_overpunch](https://hexdocs.pm/signed_overpunch).

