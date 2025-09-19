defmodule Hachiware.Poller.Runner do
  use Task

  def run do
    Hachiware.Provider.Github.read_repo!("smuwad2/week3-ice-Zachary-Tan-2022")
    |> IO.inspect()

    # IO.puts("Runner.run called")
  end
end
