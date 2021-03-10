defmodule ReportGeneratorTest do
  use ExUnit.Case
  doctest ReportGenerator

  alias ReportGenerator.Parser

  describe "call/1" do
    test "generates a report given a valid csv file" do
      filename = "data/test_small.csv"

      result =
        filename
        |> ReportGenerator.call()

      expected = %{
        all_hours: %{daniele: 12, giuliano: 3, mayk: 5},
        hours_per_month: %{
          daniele: %{abril: 7, dezembro: 5},
          giuliano: %{fevereiro: 3},
          mayk: %{dezembro: 5}
        },
        hours_per_year: %{
          daniele: %{2016 => 5, 2018 => 7},
          giuliano: %{2017 => 3},
          mayk: %{2017 => 1, 2019 => 4}
        }
      }

      assert result == expected
    end
  end

  describe "call/2" do
    test "generates a report in parallel given a valid csv file" do
      filename = "data/test_small.csv"

      result =
        filename
        |> ReportGenerator.call(:parallel)

      expected =
        filename
        # non-parallel version
        |> ReportGenerator.call()

      assert result == expected
    end
  end

  describe "get_entries_per_worker/1" do
    test "Extracts the entries corresponding to each worker" do
      filename = "data/test_small.csv"

      result =
        filename
        |> Parser.call()
        |> ReportGenerator.get_entries_per_worker()

      expected = %{
        daniele: [
          %{day: 27, hours: 5, month: :dezembro, year: 2016},
          %{day: 29, hours: 7, month: :abril, year: 2018}
        ],
        giuliano: [%{day: 13, hours: 3, month: :fevereiro, year: 2017}],
        mayk: [
          %{day: 2, hours: 1, month: :dezembro, year: 2017},
          %{day: 9, hours: 4, month: :dezembro, year: 2019}
        ]
      }

      assert expected == result
    end
  end

  describe "hours_per_year/1" do
    test "Extracts hours per year for each worker" do
      filename = "data/test_small.csv"

      result =
        filename
        |> Parser.call()
        |> ReportGenerator.hours_per_year()

      expected = %{
        daniele: %{2016 => 5, 2018 => 7},
        giuliano: %{2017 => 3},
        mayk: %{2017 => 1, 2019 => 4}
      }

      assert expected == result
    end
  end

  describe "hours_per_month/1" do
    test "Extracts hours per month for each worker" do
      filename = "data/test_small.csv"

      result =
        filename
        |> Parser.call()
        |> ReportGenerator.hours_per_month()

      expected = %{
        daniele: %{abril: 7, dezembro: 5},
        giuliano: %{fevereiro: 3},
        mayk: %{dezembro: 5}
      }

      assert expected == result
    end
  end
end
