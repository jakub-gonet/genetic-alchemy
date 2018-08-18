defmodule Chromosome do
  @enforce_keys [:genes, :fitness]

  defstruct genes: [], fitness: 0
end
