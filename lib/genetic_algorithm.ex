defmodule GeneticAlgorithm do
  import GeneticAlgorithm.Helpers

  @gene_values [0, 1]
  @mutation_chance 0.1
  @chromosomes_in_gen 500

  def find_solution(fitness_func, min_fitness),
    do: _find_solution(generate_initial_population(fitness_func), fitness_func, min_fitness, 0)

  def _find_solution(population, fitness_func, min_fitness, counter) do
    unless can_stop?(population, fitness_func, min_fitness) do
      counter = counter + 1
      gen = next_generation(population, fitness_func)
      _find_solution(gen, fitness_func, min_fitness, counter)
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

  def can_stop?(population, fitness_func, min_fitness) do
    Enum.at(population, 0).fitness >= min_fitness
  end
end
