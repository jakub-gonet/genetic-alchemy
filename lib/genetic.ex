defmodule Genetic do
  def populate(number, allowed_values, length) when number > 0 and length > 0,
    do: _populate(number, allowed_values, length, %Chromosome{})

  def populate(_, _, _), do: []

  def crossover(population)
  def mutate(population, chance)
  def calc_fitness(population, fitness_func)

  defp _populate(number, allowed_values, length, population) do
    for _ <- 1..number, do: random_chromosome(allowed_values, length)
  end

  defp random_chromosome(allowed_values, length) do
    genes = for _ <- 1..length, do: Enum.random(allowed_values)
    %Chromosome{genes: genes}
  end
end
