defmodule ReportGenerator do
  @moduledoc """
  Documentation for `ReportGenerator`.
  """

  alias ReportGenerator.Entry
  alias ReportGenerator.Parser

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
  Hello world.

  ## Examples

      iex> ReportGenerator.hello()
      :world

  """
  def hello do
    :world
  end

  def get_hours_by_worker(entries) do
    update_map = fn
      %Entry{name: name, hours: hours}, map ->
        map
        |> Map.update(name, hours, fn curr -> curr + hours end)
    end

    entries
    |> Enum.reduce(%{}, &update_map.(&1, &2))
  end

  def get_hours_per_worker_per_month(entries) do
  end

  def get_hours_per_worker_per_year(entries) do
    entries
    |> get_entries_per_worker()
    |> Enum.map()
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
end
