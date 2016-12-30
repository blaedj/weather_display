defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

defmodule WeatherDisplay.NOAAObservations do
  @moduledoc """
  Fetch the NOAA weather observations for a given location.
  """
  require Logger

  @weather_url "http://w1.weather.gov/xml/current_obs/.xml"

  def fetch(location_code) do
    Logger.info "Fetching weather observations for #{location_code}"
    response = noaa_url(location_code)
    |> HTTPoison.get
    IO.inspect(response)

    {:ok, "DUMMY DATA"}
  end
  def noaa_url(code), do: "#{@weather_url}/#{code}.xml"

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info "Successful Response"
    Logger.debug( fn -> inspect(body) end)
    { :ok, body }
  end

  def handle_response({:error, %{status_code: status, body: body}}) do
    Logger.warn "Error #{status} returned"
    { :error, body }
  end
end
