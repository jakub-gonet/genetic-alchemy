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
  @typedoc """
  `Chromosome.t` accepts `genes` as `Gene`s list and `fitness` as float in range from 0.0 to 1.0. 
  """
  @type t :: %Chromosome{genes: [Gene.t()], fitness: float()}
end
