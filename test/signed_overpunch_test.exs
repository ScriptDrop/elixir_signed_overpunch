defmodule SignedOverpunchTest do
  use ExUnit.Case
  doctest SignedOverpunch

  test "conversion works" do
    conversions = %{
      "123A" => 1231,
      "123B" => 1232,
      "123C" => 1233,
      "123D" => 1234,
      "123E" => 1235,
      "123F" => 1236,
      "123G" => 1237,
      "123H" => 1238,
      "123I" => 1239,
      "123J" => -1231,
      "123K" => -1232,
      "123L" => -1233,
      "123M" => -1234,
      "123N" => -1235,
      "123O" => -1236,
      "123P" => -1237,
      "123Q" => -1238,
      "123R" => -1239,
      "123{" => 1230,
      "123}" => -1230,
      "A" => 1,
      "B" => 2,
      "C" => 3,
      "D" => 4,
      "E" => 5,
      "F" => 6,
      "G" => 7,
      "H" => 8,
      "I" => 9,
      "J" => -1,
      "K" => -2,
      "L" => -3,
      "M" => -4,
      "N" => -5,
      "O" => -6,
      "P" => -7,
      "Q" => -8,
      "R" => -9,
      "{" => 0,
      "}" => 0,
    }

    for {original, final} <- conversions do
      assert {:ok, final} == SignedOverpunch.convert(original)
    end

    for {original, final} <- conversions do
      assert final == SignedOverpunch.convert!(original)
    end
  end

  test "string is a word" do
    assert :error == SignedOverpunch.convert("NOTANUMBER")

    assert_raise ArgumentError, "invalid signed overpunch value: NOTANUMBER", fn ->
      SignedOverpunch.convert!("NOTANUMBER")
    end
  end

  test "string is an integer" do
    assert :error == SignedOverpunch.convert("123")

    assert_raise ArgumentError, "invalid signed overpunch value: 123", fn ->
      SignedOverpunch.convert!("123")
    end
  end
end
