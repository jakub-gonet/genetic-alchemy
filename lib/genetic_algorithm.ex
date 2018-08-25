defmodule GeneticAlgorithm do
  import GeneticAlgorithm.Helpers

  @gene_values [0, 1]
  @mutation_chance 0.1
  @chromosomes_in_gen 500

  def generate_initial_population(fitness_func),
    do: populate(@chromosomes_in_gen, @gene_values, 5, fitness_func)

  def next_generation(population, fitness_func) do
    population
    |> crossover(fitness_func)
    |> mutate(@gene_values, @mutation_chance, fitness_func)
    |> select_most_fitting(@chromosomes_in_gen)
  end

  def can_stop?(population, fitness_func, min_fitness) do
    Enum.at(population, 0).fitness >= min_fitness
  end
end
