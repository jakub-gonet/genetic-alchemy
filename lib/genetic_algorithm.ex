defmodule GeneticAlgorithm do
  @moduledoc """
  This module is grouping functions from `GeneticAlgorithm.Helpers` to easily find the solution of a given problem.

  ## Options
  Those are options with their default values:
  ```
  %{
    gene_values: [{[0, 1], 1.0}],  # values used by Gene
    length: 5,            # length of a Chromosome
    chrom_in_gen: 1000,   # population size
    min_fitness: 0.9,     # minimum fitness allowing to stop
    mutation_chance: 0.1, # mutation chance
    shown_chrom: 3        # number of Chromosomes returned as solution
  }
    ```
  """
  @typedoc """
  `fitness_f` describes fitness function which should be passed to various functions.
  """
  @type fitness_f :: function(genes :: [Genes.t()]) :: float

  @typedoc """
  `solution` describes solution returned after stopping the algoritm.
  """
  @type solution :: %{generations: non_neg_integer, most_fitting: [Chromosome.t()]}
  import GeneticAlgorithm.Helpers

  @defaults %{
    gene_values: [{[0, 1], 1.0}],
    length: 5,
    chrom_in_gen: 1000,
    min_fitness: 0.9,
    mutation_chance: 0.1,
    shown_chrom: 3
  }

  @doc """
  Finds solution based on given `fitness_func`.

  For list of available options see `GeneticAlgorithm` documentation.
  """
  @spec find_solution(fitness_func :: fitness_f, opts :: keyword) :: solution
  def find_solution(fitness_func, opts \\ []) do
    _find_solution(
      generate_initial_population(fitness_func, opts),
      fitness_func,
      0,
      false,
      opts
    )
  end

  defp _find_solution(population, fitness_func, counter, found_solution?, opts)

  defp _find_solution(population, _, counter, true, opts) do
    %{shown_chrom: n} = Enum.into(opts, @defaults)
    %{generations: counter, most_fitting: select_most_fitting(population, n)}
  end

  defp _find_solution(population, fitness_func, counter, false, opts) do
    %{min_fitness: min_fitness} = Enum.into(opts, @defaults)

    if found_solution?(population, min_fitness) do
      _find_solution(population, fitness_func, counter + 1, true, opts)
    else
      gen = next_generation(population, fitness_func, opts)
      _find_solution(gen, fitness_func, counter + 1, false, opts)
    end
  end

  @doc """
  Advances `population` of one generation.

  `opts`:
  + `:mutation_chance`
  + `:gene_values`
  + `:chrom_in_gen`

  Also see `GeneticAlgorithm`.
  """
  @spec next_generation(
          population :: [Chromosome.t()],
          fitness_func :: fitness_f,
          opts :: keyword
        ) :: [Chromosome.t()]
  def next_generation(population, fitness_func, opts \\ []) do
    %{mutation_chance: mut, gene_values: v, chrom_in_gen: n} = Enum.into(opts, @defaults)

    population
    |> crossover(fitness_func)
    |> mutate(v, mut, fitness_func)
    |> select_most_fitting(n)
  end

  @doc """
  Generates new population with given `opts`.

  `opts`:
  + `:chrom_in_gen`
  + `:gene_values`
  + `:length`

  Also see `GeneticAlgorithm`.
  """
  @spec generate_initial_population(fitness_func :: fitness_f, opts :: keyword) :: [
          Chromosome.t()
        ]
  def generate_initial_population(fitness_func, opts \\ []) do
    %{chrom_in_gen: n, gene_values: v, length: len} = Enum.into(opts, @defaults)

    populate(n, v, len, fitness_func)
  end

  defp found_solution?(population, min_fitness) do
    Enum.at(population, 0).fitness >= min_fitness
  end
end
