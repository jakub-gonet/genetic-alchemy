defmodule GeneticAlgorithm.Helpers do
  def populate(number, allowed_values, length, fitness_func) when number > 0 and length > 0 do
    Flow.from_enumerable(1..number)
    |> Flow.reduce(fn -> [] end, fn _, acc ->
      [generate_random_chromosome(allowed_values, length, fitness_func) | acc]
    end)
    |> Enum.to_list()
  end

  def populate(_, _, _), do: []

  def rulette_select(population, count) do
    _rulette_select(population, count, [])
  end

  def _rulette_select(_, count, new_population)
      when length(new_population) == count,
      do: new_population

  def _rulette_select(population, count, new_population) do
    choice = Enum.random(population)

    new_population =
      if :rand.uniform() <= choice.fitness do
        [choice | new_population]
      else
        new_population
      end

    _rulette_select(population, count, new_population)
  end

  def crossover(population, fitness_func) do
    population
    |> Enum.chunk_every(2)
    |> Flow.from_enumerable()
    |> Flow.flat_map(&crossover_two(&1, fitness_func))
    |> Enum.to_list()
  end

  def mutate(population, allowed_values, chance, fitness_func) do
    population
    |> Flow.from_enumerable()
    |> Flow.map(&mutate_one(&1, allowed_values, chance, fitness_func))
    |> Enum.to_list()
  end

  def select_most_fitting(population, number) do
    population
    |> Enum.sort_by(fn chrom -> chrom.fitness end, &>=/2)
    |> Enum.take(number)
  end

  defp generate_random_chromosome(allowed_values, length, fitness_func) do
    genes = for _ <- 1..length, do: %Gene{v: Enum.random(allowed_values)}
    create_chromosome(genes, fitness_func)
  end

  defp create_chromosome(genes, fitness_func) do
    %Chromosome{genes: genes, fitness: fitness_func.(genes)}
  end

  defp crossover_two([%Chromosome{genes: first}, %Chromosome{genes: second}], fitness_func) do
    merge_swapped = fn {a_1, a_2}, {b_1, b_2} -> {a_1 ++ b_2, b_1 ++ a_2} end

    crossover_point = pivot_from_list(first)
    first_split = Enum.split(first, crossover_point)
    second_split = Enum.split(second, crossover_point)

    {first_m, second_m} = merge_swapped.(first_split, second_split)
    [create_chromosome(first_m, fitness_func), create_chromosome(second_m, fitness_func)]
  end

  defp crossover_two(first), do: first

  defp pivot_from_list(list), do: Enum.random(0..(length(list) - 1))

  defp mutate_one(%Chromosome{genes: genes}, allowed_values, chance, fitness_func) do
    genes =
      if :rand.uniform() <= chance do
        random_gene = %Gene{v: Enum.random(allowed_values)}
        random_pos = pivot_from_list(genes)
        List.replace_at(genes, random_pos, random_gene)
      else
        genes
    end

    create_chromosome(genes, fitness_func)
  end
end
