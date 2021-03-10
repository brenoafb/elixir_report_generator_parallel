defmodule ReportGenerator do
  @moduledoc """
  Generates time-tracking reports.
  """

  alias ReportGenerator.Entry
  alias ReportGenerator.Parser

  def call(filename) do
    functions = [:all_hours, :hours_per_month, :hours_per_year]

    filename
    |> Parser.call()
    |> build_map_from_results(functions)
  end

  def call(filename, :parallel) do
    functions = [:all_hours, :hours_per_month, :hours_per_year]

    filename
    |> Parser.call()
    |> build_map_from_results(functions, :parallel)
  end

  def all_hours(entries) do
    update_map = fn
      %Entry{name: name, hours: hours}, map ->
        map
        |> Map.update(name, hours, fn curr -> curr + hours end)
    end

    entries
    |> Enum.reduce(%{}, &update_map.(&1, &2))
  end

  def hours_per_month(entries) do
    entries
    |> get_entries_per_worker()
    |> Enum.map(fn {name, entries} ->
      {name, extract_value_by_key(entries, :month, :hours, fn x, y -> x + y end)}
    end)
    |> assoc_list_to_map()
  end

  def hours_per_year(entries) do
    entries
    |> get_entries_per_worker()
    |> Enum.map(fn {name, entries} ->
      {name, extract_value_by_key(entries, :year, :hours, fn x, y -> x + y end)}
    end)
    |> assoc_list_to_map()
  end

  def get_entries_per_worker(entries) do
    update_map = fn
      %Entry{name: name, hours: hours, day: day, month: month, year: year}, map ->
        entry = %{hours: hours, day: day, month: month, year: year}

        map
        |> Map.update(name, [entry], fn curr -> [entry | curr] end)
    end

    entries
    |> Enum.reduce(%{}, &update_map.(&1, &2))
  end

  defp extract_value_by_key(xs, key, value, combine) do
    xs
    |> List.foldr(%{}, fn x, map ->
      k = x[key]
      v = x[value]
      map |> Map.update(k, v, &combine.(v, &1))
    end)
  end

  defp assoc_list_to_map(al) do
    al
    |> Enum.reduce(%{}, fn {k, v}, map -> map |> Map.put(k, v) end)
  end

  defp build_map_from_results(entries, functions) do
    functions
    |> List.foldr(%{}, fn f, map ->
      result = apply(__MODULE__, f, [entries])
      map |> Map.put(f, result)
    end)
  end

  defp build_map_from_results(entries, functions, :parallel) do
    functions
    |> Task.async_stream(fn f -> {f, apply(__MODULE__, f, [entries])} end)
    |> Enum.reduce(%{}, fn {:ok, {f, result}}, map -> map |> Map.put(f, result) end)
  end
end
