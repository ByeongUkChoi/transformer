# Transformer
Transformer is lightweight library that helps with flexible type conversion.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `transformer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:transformer, "~> 0.0.1"}
  ]
end
```

## Usage

Convert to integer without error.  
If it cannot be converted, it returns a substitute.  
```elixir
iex> Transformer.to_integer_or(1)
1

iex> Transformer.to_integer_or("2")
2

iex> Transformer.to_integer_or("a")
"a"

iex> Transformer.to_integer_or("a", nil)
nil

iex> Transformer.to_integer_or("a", & &1 <> &1)
"aa"
```

Divides a string and convert to integer list without error.  
If it cannot be converted, it returns a substitute.  
```elixir
iex> Transformer.to_integer_list_or("1")
[1]

iex> Transformer.to_integer_list_or("1,2")
[1, 2]

iex> Transformer.to_integer_list_or("1,a")
[1, "a"]

iex> Transformer.to_integer_list_or("1,a", nil)
[1, nil]

iex> Transformer.to_integer_list_or([1, 2])
[1, 2]

iex> Transformer.to_integer_list_or(["a", 2], nil)
[nil, 2]
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/transformer>.

## License

Copyright 2022 ByeongUk Choi

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
