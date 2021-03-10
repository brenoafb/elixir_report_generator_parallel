defmodule ReportGenerator.Parser do
  @moduledoc """
  Parses csv files describing time tracking data into a structured list of maps.
  """

  alias ReportGenerator.Entry

  @doc """
  Parser time tracking entries
  The input is a csv file containing entries with format

    name,hours,day,month,year

  Returns a list of entries (view ReportGenerator.Entry)

  """
  def call(filename) do
    filename
    |> File.stream!()
    |> Stream.map(&parse_line(&1))
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> process_tokens
  end

  defp process_tokens([name, hours, day, month, year]) do
    %Entry{
      name: name,
      hours: hours |> String.to_integer(),
      day: day |> String.to_integer(),
      month: month |> String.to_integer(),
      year: year |> String.to_integer()
    }
  end
end
