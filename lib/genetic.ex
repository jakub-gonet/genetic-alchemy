defmodule Genetic do
  def populate(number, allowed_values, length) when number > 0 and length > 0,
    do: for(_ <- 1..number, do: random_chromosome(allowed_values, length))

  def populate(_, _, _), do: []

  def crossover(population)
  def mutate(population, chance)
  def calc_fitness(population, fitness_func)

  defp random_chromosome(allowed_values, length) do
    genes = for _ <- 1..length, do: Enum.random(allowed_values)
    %Chromosome{genes: genes}
  end

  def crossover_two([%Chromosome{genes: first}, %Chromosome{genes: second}]) do
    merge_swapped = fn {a_1, a_2}, {b_1, b_2} -> {a_1 ++ b_2, b_1 ++ a_2} end

    crossover_point = crossover_point_from(length(first))
    first_split = Enum.split(first, crossover_point)
    second_split = Enum.split(second, crossover_point)

    {first_m, second_m} = merge_swapped.(first_split, second_split)
    [%Chromosome{genes: first_m}, %Chromosome{genes: second_m}]
  end

  def crossover_two(first), do: first

  defp crossover_point_from(length), do: Enum.random(1..length)
end
