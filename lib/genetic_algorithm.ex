defmodule GeneticAlgorithm do
  def can_stop?(population, fitness_func, min_fitness) do
    Enum.at(population, 0).fitness >= min_fitness
  end
end
