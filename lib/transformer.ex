defprotocol Transformer do
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
end

defimpl Transformer, for: Integer do
  def to_integer_or(value, _substitute) do
    value
  end

  def to_integer_list_or(value, substitute, _split_pattern) do
    if is_function(substitute) do
      substitute.(value)
    else
      substitute
    end
  end

  def to_float_or(value, _substitute) do
    value * 1.0
  end
end

defimpl Transformer, for: BitString do
  def to_integer_or(value, substitute) do
    try do
      String.to_integer(value)
    rescue
      _ -> to_substitute(value, substitute)
    end
  end

  def to_integer_list_or(value, substitute, split_pattern) do
    value
    |> String.split(split_pattern, trim: true)
    |> Enum.map(&to_integer_or(&1, substitute))
  end

  def to_float_or(value, substitute) do
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

  defp to_substitute(value, substitute) when is_function(substitute) do
    substitute.(value)
  end

  defp to_substitute(_value, substitute) do
    substitute
  end
end

defimpl Transformer, for: Float do
  def to_integer_or(_value, substitute), do: substitute
  def to_integer_list_or(_value, substitute, _split_pattern), do: substitute
  def to_float_or(value, _substitute), do: value
end

defimpl Transformer, for: List do
  def to_integer_or(_value, substitute), do: substitute

  def to_integer_list_or(value, substitute, _split_pattern),
    do: Enum.map(value, &Transformer.to_integer_or(&1, substitute))

  def to_float_or(_value, substitute), do: substitute
end

defimpl Transformer, for: Any do
  def to_integer_or(_value, substitute), do: substitute
  def to_integer_list_or(_value, substitute, _split_pattern), do: substitute
  def to_float_or(_value, substitute), do: substitute
end
