defmodule ReportGenerator.Entry do
  @moduledoc """
  Defines a time-tracking entry
  """
  defstruct [:name, :hours, :day, :month, :year]
end
