defmodule Hachiware.Reports.TestSummary do
  use Ash.TypedStruct

  typed_struct do
    field :total_tests, :integer, constraints: [min: 0]
    field :passed, :integer, constraints: [min: 0]
    field :warnings, :integer, constraints: [min: 0]
    field :failures, :integer, constraints: [min: 0]
    field :exceptions, :integer, constraints: [min: 0]
  end
end
