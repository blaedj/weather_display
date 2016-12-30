defmodule CliTest do
  use ExUnit.Case
  doctest WeatherDisplay

  import WeatherDisplay.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing when -h or --help given" do
    assert parse_args(["-h", "gibberish"])     == :help
    assert parse_args(["--help", "gibberish"]) == :help
  end

  test "the given weather code is returned" do
    assert parse_args(["ABCD"]) == "ABCD"
  end

end
