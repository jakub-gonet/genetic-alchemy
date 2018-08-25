defmodule Chromosome do
@moduledoc """
This struct is representing single Chromosome.
It contains two keys: `genes` and `fitness`.
`genes` is used for storing Genes comprising into chromosome data.
`fitness` stores overall Chromosome fitness.
"""
  defstruct genes: [], fitness: 0
end
