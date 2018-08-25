defmodule GeneticAlgorithm do
  import GeneticAlgorithm.Helpers

  @defaults %{
    gene_values: [0, 1],
    length: 5,
    chrom_in_gen: 1000,
    min_fitness: 0.9,
    mutation_chance: 0.1
  }

  def find_solution(fitness_func, opts \\ []) do
    _find_solution(
      generate_initial_population(fitness_func, opts),
      fitness_func,
      0,
      opts
    )
  end

  defp _find_solution(population, fitness_func, counter, opts) do
    %{min_fitness: min_fitness} = Enum.into(opts, @defaults)

    unless can_stop?(population, min_fitness) do
      gen = next_generation(population, fitness_func, opts)
      _find_solution(gen, fitness_func, counter + 1, opts)
    else
      %{generations: counter, most_fitting: select_most_fitting(population, 3)}
    end
  end

  def generate_initial_population(fitness_func),
    do: populate(@chromosomes_in_gen, @gene_values, 5, fitness_func)

  def next_generation(population, fitness_func) do
    population
    |> crossover(fitness_func)
    |> mutate(@gene_values, @mutation_chance, fitness_func)
    |> select_most_fitting(@chromosomes_in_gen)
  end

  defp can_stop?(population, min_fitness) do
    Enum.at(population, 0).fitness >= min_fitness
  end
end
