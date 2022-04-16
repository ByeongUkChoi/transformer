defmodule Transformer do
  @moduledoc """
  Provides functions for type converting
  """

  @doc """
  Convert to integer without error.
  If it cannot be converted, it returns a substitute.

  ## Examples

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

  """
  @spec to_integer_or(integer() | String.t() | nil, any()) :: integer() | any()
  def to_integer_or(value, substitute \\ & &1)

  def to_integer_or(value, _substitute) when is_integer(value) do
    value
  end

  def to_integer_or(value, substitute) when is_binary(value) do
    try do
      String.to_integer(value)
    rescue
      _ -> to_substitute(value, substitute)
    end
  end

  def to_integer_or(value, substitute) do
    to_substitute(value, substitute)
  end

  defp to_substitute(value, substitute) when is_function(substitute) do
    substitute.(value)
  end

  defp to_substitute(_value, substitute) do
    substitute
  end

  @doc """
  Divides a string and convert to integer list without error.
  If it cannot be converted, it returns a substitute.

  ## Examples

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
  """
  @spec to_integer_list_or(String.t() | list(), any(), String.t()) :: list()
  def to_integer_list_or(value, substitute \\ & &1, split_pattern \\ ",")

  def to_integer_list_or(value, substitute, split_pattern) when is_binary(value) do
    value
    |> String.split(split_pattern, trim: true)
    |> Enum.map(&to_integer_or(&1, substitute))
  end

  def to_integer_list_or(value, substitute, _) when is_list(value) do
    value |> Enum.map(&to_integer_or(&1, substitute))
  end
end
