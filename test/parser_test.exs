defmodule ReportGenerator.ParserTest do
  use ExUnit.Case
  doctest ReportGenerator
  alias ReportGenerator.Parser

  # test "greets the world" do
  #   assert ReportGenerator.hello() == :world
  # end

  describe "call/1" do
    test "parses a valid csv file" do
      filename = "data/test_small.csv"

      response =
        filename
        |> Parser.call()
        |> Enum.map(& &1)

      expected = [
        %ReportGenerator.Entry{
          day: 29,
          hours: 7,
          month: :abril,
          name: :daniele,
          year: 2018
        },
        %ReportGenerator.Entry{
          day: 9,
          hours: 4,
          month: :dezembro,
          name: :mayk,
          year: 2019
        },
        %ReportGenerator.Entry{
          day: 27,
          hours: 5,
          month: :dezembro,
          name: :daniele,
          year: 2016
        },
        %ReportGenerator.Entry{
          day: 2,
          hours: 1,
          month: :dezembro,
          name: :mayk,
          year: 2017
        },
        %ReportGenerator.Entry{
          day: 13,
          hours: 3,
          month: :fevereiro,
          name: :giuliano,
          year: 2017
        }
      ]

      assert response == expected
    end
  end
end
