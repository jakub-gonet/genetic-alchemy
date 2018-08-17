defmodule Genetic do
  def populate(number, allowed_values, length) when number > 0 and length > 0,
    do: for(_ <- 1..number, do: generate_random_chromosome(allowed_values, length))

  def populate(_, _, _), do: []

  def crossover(population) do
    population
    |> Enum.chunk_every(2)
    |> Flow.from_enumerable()
    |> Flow.flat_map(&crossover_two(&1))
    |> Enum.to_list()
  end

  def mutate(population, chance)
  def calc_fitness(population, fitness_func)

  defp generate_random_chromosome(allowed_values, length) do
    genes = for _ <- 1..length, do: %Gene{v: Enum.random(allowed_values)}
    %Chromosome{genes: genes}
  end

  defp crossover_two([%Chromosome{genes: first}, %Chromosome{genes: second}]) do
    merge_swapped = fn {a_1, a_2}, {b_1, b_2} -> {a_1 ++ b_2, b_1 ++ a_2} end

    crossover_point = pivot_from(length(first))
    first_split = Enum.split(first, crossover_point)
    second_split = Enum.split(second, crossover_point)

    {first_m, second_m} = merge_swapped.(first_split, second_split)
    [%Chromosome{genes: first_m}, %Chromosome{genes: second_m}]
  end

  defp crossover_two(first), do: first

  defp pivot_from(length), do: Enum.random(1..length)
end
