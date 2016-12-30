defmodule WeatherDisplay.CLI do
  @moduledoc """
  Handle the command line parsing and dispatch to various functions that end
  up generating the pretty output for displaying weather on the command line.
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be '--help' which returns :help.
  Otherwise it should be an airport code that corresponds to an airport to fetch
  weather observations for.
  returns `"location_code"`, or `:help` if help was given
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean ],
                                     aliases:  [ h:    :help    ])
    case parse do
      { [help: true], _, _ } -> :help
      { _, [code | _ ],  _ } -> code
      _                      -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: weather_display <location-code>
    """
  end

  def process(location_code) do
    WeatherDisplay.NOAAObservations.fetch(location_code)
    |> decode_response
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from weather.gov: #{message}"
    System.halt(2)
  end

end
