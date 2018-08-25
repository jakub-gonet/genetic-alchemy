defmodule Chromosome do
  @moduledoc """
  This struct is representing a single Chromosome.  

  It contains two keys: `genes` and `fitness`:
  + `genes` is used for storing Genes comprising into chromosome data.  
  + `fitness` stores overall Chromosome fitness.  

  ## Example
  ```
  # Create new Chromosome with two genes.
  %Chromosome{genes: [%Gene{v: 1}, %Gene{v: 0}], fitness: 1.0}
  ```
  """
  defstruct genes: [], fitness: 0
end
