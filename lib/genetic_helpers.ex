defmodule GeneticAlgorithm.Helpers do
  @moduledoc """
  This module is grouping functions used to generate, crossover and mutate genetic algoritm chromosomes population.
  """
  @type fitness_f :: function(genes :: [Genes.t()]) :: float

  @doc """
  Generates new random population with given parameters.

  + `size` - population size 
  + `allowed_values` - values used as `Gene` values
  + `length` - amount of `Gene`s in `Chromosome`
  + `fitness_func` - function calculating `Chromosome` fitness

  ## Examples
  ```
  iex> GeneticAlgorithm.Helpers.populate(2, [0], 1, fn _ -> 1.0 end)
  [
    %Chromosome{fitness: 1.0, genes: [%Gene{v: 0}]},
    %Chromosome{fitness: 1.0, genes: [%Gene{v: 0}]}
  ]

  iex> GeneticAlgorithm.Helpers.populate(0, [0], 1, fn _ -> 1.0 end)
  []
  ```
  """
  @spec populate(
          size :: non_neg_integer,
          allowed_values :: list,
          length :: non_neg_integer,
          fitness_func :: fitness_f
        ) :: [Chromosome.t()]
  def populate(size, allowed_values, length, fitness_func) when size > 0 do
    1..size
    |> Flow.from_enumerable()
    |> Flow.reduce(fn -> [] end, fn _, acc ->
      [generate_random_chromosome(allowed_values, length, fitness_func) | acc]
    end)
    |> Enum.to_list()
  end

  def populate(_, _, _, _), do: []

  @doc """
  Selects `n` elements from a `population` according to their fitness.

  If `Chromosome` has more fitness it has greater chance to be chosen.
  """
  @spec rulette_select(population :: [Chromosome.t()], n :: non_neg_integer) :: [Chromosome.t()]
  def rulette_select(population, n) when n > 0 do
    packed = Enum.reduce(population, [], fn x, acc -> [{x, x.fitness} | acc] end)
    Enum.map(1..n, fn _ -> random_based_on_fitness(packed) end)
  end

  @doc """
  Crossovers `Chromosome`s in given `population`.

  Creates new `population` based on previous and having same amount of elements.
  """
  @spec crossover(population :: [Chromosome.t()], fitness_func :: fitness_f) :: [Chromosome.t()]
  def crossover(population, fitness_func) do
    population
    |> Enum.chunk_every(2)
    |> Flow.from_enumerable()
    |> Flow.reduce(fn -> [] end, fn elem, acc ->
      [rulette_select(population, length(elem)) | acc]
    end)
    |> Flow.flat_map(&crossover_two(&1, fitness_func))
    |> Enum.to_list()
  end

  @doc """
  Mutates every `Chromosome` in `population` with given `chance`.

  ## Example
  ```
  iex> p = [%Chromosome{fitness: 1.0, genes: [%Gene{v: 0}]}]
  iex> GeneticAlgorithm.Helpers.mutate(p, [0, 1], 1.0, fn _ -> 1.0 end)
  [%Chromosome{fitness: 1.0, genes: [%Gene{v: 1}]}]
  ```
  """
  @spec mutate(
          population :: [Chromosome.t()],
          allowed_values :: list,
          chance :: float,
          fitness_func :: fitness_f
        ) :: [Chromosome.t()]
  def mutate(population, allowed_values, chance, fitness_func) do
    population
    |> Flow.from_enumerable()
    |> Flow.map(&mutate_one(&1, allowed_values, chance, fitness_func))
    |> Enum.to_list()
  end

  @doc """
  Selects `n` most fitting `Chromosome`s from a `population`.

  `Chromosome`s are sorted by fitness, ascending.
  """
  @spec select_most_fitting(population :: [Chromosome.t()], n :: non_neg_integer) :: [
          Chromosome.t()
        ]
  def select_most_fitting(population, n) do
    population
    |> Enum.sort_by(fn chrom -> chrom.fitness end, &>=/2)
    |> Enum.take(n)
  end

  defp generate_random_chromosome(allowed_values, length, fitness_func)
       when length > 0 and length(allowed_values) > 0 do
    genes = for _ <- 1..length, do: %Gene{v: Enum.random(allowed_values)}
    create_chromosome(genes, fitness_func)
  end

  defp generate_random_chromosome(_, _, fitness_func), do: create_chromosome([], fitness_func)

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

  defp crossover_two(first, _), do: first

  defp pivot_from_list(list), do: Enum.random(0..(length(list) - 1))

  defp mutate_one(%Chromosome{genes: genes}, allowed_values, chance, fitness_func) do
    genes =
      if :rand.uniform() <= chance do
        random_pos = pivot_from_list(genes)
        current_gene = Enum.at(genes, random_pos).v
        random_gene = %Gene{v: Enum.random(allowed_values -- [current_gene])}
        List.replace_at(genes, random_pos, random_gene)
      else
        genes
      end

    create_chromosome(genes, fitness_func)
  end

  defp random_based_on_fitness(list) do
    total_p =
      list
      |> Enum.map(fn {_, p} -> p end)
      |> Enum.sum()

    random = :rand.uniform() * total_p

    try_random = fn x, acc ->
      {val, p} = x
      acc = acc + p

      if random > acc, do: {:cont, acc}, else: {:halt, val}
    end

    Enum.reduce_while(list, 0, try_random)
  end
end
