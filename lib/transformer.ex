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

      iex> Transformer.to_integer_or("a", &{:error, &1})
      {:error, "a"}

  """
  @spec to_integer_or(any(), any()) :: integer() | any()
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

      iex> Transformer.to_integer_list_or(["a", 2], &{:error, &1})
      [{:error, "a"}, 2]
  """
  @spec to_integer_list_or(any(), any(), String.t()) :: list()
  def to_integer_list_or(value, substitute \\ & &1, split_pattern \\ ",")

  def to_integer_list_or(value, substitute, split_pattern) when is_binary(value) do
    value
    |> String.split(split_pattern, trim: true)
    |> Enum.map(&to_integer_or(&1, substitute))
  end

  def to_integer_list_or(value, substitute, _) when is_list(value) do
    value |> Enum.map(&to_integer_or(&1, substitute))
  end

  @doc """
  Convert to float without error.
  If it cannot be converted, it returns a substitute.

  ## Examples

      iex> Transformer.to_float_or(1)
      1.0

      iex> Transformer.to_float_or(1.2)
      1.2

      iex> Transformer.to_float_or("2")
      2.0

      iex> Transformer.to_float_or("a")
      "a"

      iex> Transformer.to_float_or("a", nil)
      nil

      iex> Transformer.to_float_or("a", &{:error, &1})
      {:error, "a"}

  """
  @spec to_float_or(any(), any()) :: float() | any()
  def to_float_or(value, substitute \\ & &1)

  def to_float_or(value, _substitute) when is_float(value) do
    value
  end

  def to_float_or(value, _substitute) when is_integer(value) do
    value * 1.0
  end

  def to_float_or(value, substitute) when is_binary(value) do
    try do
      String.to_float(value)
    rescue
      _ ->
        try do
          String.to_integer(value) * 1.0
        rescue
          _ -> to_substitute(value, substitute)
        end
    end
  end

  def to_float_or(value, substitute) do
    to_substitute(value, substitute)
  end
end
