defmodule SignedOverpunch do
  @error_message "invalid signed overpunch value: "

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
    |> get_profile(string)
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
      ** (ArgumentError) invalid signed overpunch value: 000

      iex> SignedOverpunch.convert!("GOTCHA")
      ** (ArgumentError) invalid signed overpunch value: GOTCHA
  """
  def convert!(string) do
    case convert(string) do
      {:ok, int} -> int
      :error -> raise ArgumentError, @error_message <> string
    end
  end

  @doc """
  Converts an integer to signed overpunch format.

  If successful, returns a tuple in the form of `{:ok, string}`. Otherwise, it
  returns `:error`.

  ## Examples

      iex> SignedOverpunch.to_s(1000)
      {:ok, "100{"}

      iex> SignedOverpunch.to_s(-1000)
      {:ok, "100}"}

      iex> SignedOverpunch.to_s(9)
      {:ok, "I"}

      iex> SignedOverpunch.to_s("GOTCHA")
      :error
  """
  def to_s(int) when is_integer(int) do
    last_digit = int
                 |> Kernel.to_string
                 |> String.last
                 |> String.to_integer

    suffix = profile({sign(int), last_digit})

    s = int
    |> convert_to_positive
    |> Kernel.to_string
    |> String.slice(0..-2)
    |> Kernel.<>(suffix)

    {:ok, s}
  end
  def to_s(_), do: :error

  @doc """
  Converts an integer to signed overpunch format.

  Similar to `SignedOverpunch.to_string/1`, but raises an `ArgumentError` if the
  input provided is not an integer.

  ## Examples

      iex> SignedOverpunch.to_s!(1000)
      "100{"

      iex> SignedOverpunch.to_s!(-1000)
      "100}"

      iex> SignedOverpunch.to_s!(9)
      "I"

      iex> SignedOverpunch.to_s!("000")
      ** (ArgumentError) invalid integer: 000

      iex> SignedOverpunch.to_s!("GOTCHA")
      ** (ArgumentError) invalid integer: GOTCHA

      iex> SignedOverpunch.to_s!(10.0)
      ** (ArgumentError) invalid integer: 10.0
  """
  def to_s!(int) do
    case to_s(int) do
      {:ok, string} -> string
      :error -> raise ArgumentError, "invalid integer: #{int}"
    end
  end

  defp sign(int) when int >= 0, do: :pos
  defp sign(int) when int < 0, do: :neg

  defp convert_to_positive(int) when int < 0, do: int * -1
  defp convert_to_positive(int) when int >= 0, do: int

  defp perform_conversion({int, {neg_or_pos, add}}) do
    {neg_or_pos, int * 10 + add}
  end
  defp perform_conversion(_), do: :error

  defp apply_sign({:pos, int}) when is_integer(int), do: int
  defp apply_sign({:neg, int}) when is_integer(int), do: 0 - int
  defp apply_sign(_), do: :error

  defp get_profile({int, overpunch_char}, _) do
    {int, profile(overpunch_char)}
  end
  # This handles the "specialish" case where only the overpunch char is present
  # and Integer.parse returns :error
  defp get_profile(:error, string) when byte_size(string) == 1 do
    {0, profile(string)}
  end
  defp get_profile(_, _), do: :error

  defp format_return(int) when is_integer(int), do: {:ok, int}
  defp format_return(:error), do: :error

  @profiles %{
    "}" => {:neg, 0},
    "J" => {:neg, 1},
    "K" => {:neg, 2},
    "L" => {:neg, 3},
    "M" => {:neg, 4},
    "N" => {:neg, 5},
    "O" => {:neg, 6},
    "P" => {:neg, 7},
    "Q" => {:neg, 8},
    "R" => {:neg, 9},
    "{" => {:pos, 0},
    "A" => {:pos, 1},
    "B" => {:pos, 2},
    "C" => {:pos, 3},
    "D" => {:pos, 4},
    "E" => {:pos, 5},
    "F" => {:pos, 6},
    "G" => {:pos, 7},
    "H" => {:pos, 8},
    "I" => {:pos, 9},
  }

  for {string, profile} <- @profiles do
    defp profile(unquote(string)) do
      unquote(profile)
    end

    defp profile(unquote(profile)) do
      unquote(string)
    end
  end
  defp profile(_), do: :error
end
