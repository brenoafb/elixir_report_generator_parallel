defmodule ReportGenerator.Parser do
  @moduledoc """
  Parses csv files describing time tracking data into a structured list of maps.
  """

  alias ReportGenerator.Entry

  @months %{
    1 => "janeiro",
    2 => "fevereiro",
    3 => "março",
    4 => "abril",
    5 => "maio",
    6 => "junho",
    7 => "julho",
    8 => "agosto",
    9 => "setembro",
    10 => "outubro",
    11 => "novembro",
    12 => "dezembro"
  }

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
      name: name |> String.downcase() |> String.to_atom(),
      hours: hours |> String.to_integer(),
      day: day |> String.to_integer(),
      month: month |> String.to_integer() |> get_month_name,
      year: year |> String.to_integer()
    }
  end

  defp get_month_name(month) do
    Map.get(@months, month) |> String.to_atom()
  end
end
