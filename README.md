# ReportGenerator

Processes time-tracking data in CSV format in Elixir.

```elixir
❯ iex -S mix
Erlang/OTP 23 [erts-11.1.7] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Interactive Elixir (1.11.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> "data/test_small.csv" |> ReportGenerator.call
%{
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
```
