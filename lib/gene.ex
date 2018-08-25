defmodule Gene do
  @moduledoc """
  This struct is representing a single value in Chromosome.

  Its key `v` is used for storing value of Gene

  ## Example
    ```
    # Create new Gene with some value.
    %Gene{v: 1}
    ```
  """
  defstruct [:v]
end
