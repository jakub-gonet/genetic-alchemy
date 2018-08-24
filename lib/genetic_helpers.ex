defmodule GeneticAlgorithm.Helpers do
  def populate(number, allowed_values, length) when number > 0 and length > 0 do
    Flow.from_enumerable(1..number)
    |> Flow.reduce(fn -> [] end, fn _, acc ->
      [generate_random_chromosome(allowed_values, length) | acc]
    end)
    |> Enum.to_list()
  end

  def populate(_, _, _), do: []

  def crossover(population) do
    population
    |> Enum.chunk_every(2)
    |> Flow.from_enumerable()
    |> Flow.flat_map(&crossover_two/1)
    |> Enum.to_list()
  end

  def mutate(population, allowed_values, chance) do
    population
    |> Flow.from_enumerable()
    |> Flow.map(&mutate_one(&1, allowed_values, chance))
    |> Enum.to_list()
  end

  def select_most_fitting(population, number, fitness_func) do
    population
    |> Flow.from_enumerable()
    |> Flow.map(&{&1, fitness_func.(&1)})
    |> Enum.sort_by(fn {_, fitness} -> fitness end)
    |> Enum.map(fn {chrom, _} -> chrom end)
    |> Enum.take(number)
  end

  defp generate_random_chromosome(allowed_values, length) do
    genes = for _ <- 1..length, do: %Gene{v: Enum.random(allowed_values)}
    %Chromosome{genes: genes}
  end

  defp create_chromosome(genes, fitness_func) do
    %Chromosome{genes: genes, fitness: fitness_func.(genes)}
  end

  defp crossover_two([%Chromosome{genes: first}, %Chromosome{genes: second}]) do
    merge_swapped = fn {a_1, a_2}, {b_1, b_2} -> {a_1 ++ b_2, b_1 ++ a_2} end

    crossover_point = pivot_from_list(first)
    first_split = Enum.split(first, crossover_point)
    second_split = Enum.split(second, crossover_point)

    {first_m, second_m} = merge_swapped.(first_split, second_split)
    [%Chromosome{genes: first_m}, %Chromosome{genes: second_m}]
  end

  defp crossover_two(first), do: first

  defp pivot_from_list(list), do: Enum.random(0..(length(list) - 1))

  defp mutate_one(%Chromosome{genes: genes}, allowed_values, chance) do
    genes =
      if :rand.uniform() <= chance do
        random_gene = %Gene{v: Enum.random(allowed_values)}
        random_pos = pivot_from_list(genes)
        List.replace_at(genes, random_pos, random_gene)
      else
        genes
    end

    %Chromosome{genes: genes}
  end
end
