defmodule SignedOverpunch do
  @error_message "invalid signed overpunch"

  @moduledoc """
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
  """

  @doc """
  Converts a string in signed overpunch format to an integer.

  If successful, returns a tuple in the form of `{:ok, integer}`. Otherwise, it
  returns `:error`.

  ## Examples

      iex> SignedOverpunch.convert("100{")
      {:ok, 1000}

      iex> SignedOverpunch.convert("100}")
      {:ok, -1000}

      iex> SignedOverpunch.convert("00I")
      {:ok, 9}

      iex> SignedOverpunch.convert("000")
      :error

      iex> SignedOverpunch.convert("GOTCHA")
      :error
  """
  def convert(string) when is_bitstring(string) do
    string
    |> Integer.parse
    |> get_profile
    |> perform_conversion
    |> apply_sign
    |> format_return
  end

  @doc """
  Converts a string in signed overpunch format to an integer.

  Similar to `SignedOverpunch.convert/1`, but raises an `ArgumentError` if the
  input provided is not valid signed overpunch.

  ## Examples

      iex> SignedOverpunch.convert!("100{")
      1000

      iex> SignedOverpunch.convert!("100}")
      -1000

      iex> SignedOverpunch.convert!("00I")
      9

      iex> SignedOverpunch.convert!("000")
      ** (ArgumentError) invalid signed overpunch

      iex> SignedOverpunch.convert!("GOTCHA")
      ** (ArgumentError) invalid signed overpunch
  """
  def convert!(string) do
    case convert(string) do
      {:ok, int} -> int
      :error -> raise ArgumentError, @error_message
    end
  end

  defp perform_conversion({int, {neg_or_pos, add}}) do
    {neg_or_pos, int * 10 + add}
  end
  defp perform_conversion(_), do: :error

  defp apply_sign({:pos, int}) when is_integer(int), do: int
  defp apply_sign({:neg, int}) when is_integer(int), do: 0 - int
  defp apply_sign(_), do: :error

  defp get_profile({int, overpunch_char}) do
    {int, profile(overpunch_char)}
  end
  defp get_profile(_), do: :error

  defp format_return(int) when is_integer(int), do: {:ok, int}
  defp format_return(:error), do: :error

  defp profile("}"), do: {:neg, 0}
  defp profile("J"), do: {:neg, 1}
  defp profile("K"), do: {:neg, 2}
  defp profile("L"), do: {:neg, 3}
  defp profile("M"), do: {:neg, 4}
  defp profile("N"), do: {:neg, 5}
  defp profile("O"), do: {:neg, 6}
  defp profile("P"), do: {:neg, 7}
  defp profile("Q"), do: {:neg, 8}
  defp profile("R"), do: {:neg, 9}
  defp profile("{"), do: {:pos, 0}
  defp profile("A"), do: {:pos, 1}
  defp profile("B"), do: {:pos, 2}
  defp profile("C"), do: {:pos, 3}
  defp profile("D"), do: {:pos, 4}
  defp profile("E"), do: {:pos, 5}
  defp profile("F"), do: {:pos, 6}
  defp profile("G"), do: {:pos, 7}
  defp profile("H"), do: {:pos, 8}
  defp profile("I"), do: {:pos, 9}
  defp profile(_), do: :error
end
