defmodule SignedOverpunchTest do
  use ExUnit.Case
  doctest SignedOverpunch

  test "conversion works" do
    conversions = %{
      "123}" => -1230,
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
      "123A" => 1231,
      "123B" => 1232,
      "123C" => 1233,
      "123D" => 1234,
      "123E" => 1235,
      "123F" => 1236,
      "123G" => 1237,
      "123H" => 1238,
      "123I" => 1239,
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
