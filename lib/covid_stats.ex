defmodule CovidStats do
  HTTPoison.start()

  response =
    "https://api.covid19api.com/summary"
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Poison.decode!()

  response
  |> Map.get("Countries")
  |> Enum.each(fn country ->
    def unquote(String.to_atom(country["Slug"]))() do
      country_data = unquote(Macro.escape(country))

      for {key, val} <- country_data do
        IO.puts("\t#{key}: #{val}")
      end

      :ok
    end
  end)

  global_data = Map.get(response, "Global")

  def global(), do: unquote(Macro.escape(global_data))
end
