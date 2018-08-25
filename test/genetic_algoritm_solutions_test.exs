defmodule GeneticAlgoritmSolutionTest do
  use ExUnit.Case, async: true
  require Logger

  def pattern_fitness(genes) do
    desired = [%Gene{v: 1}, %Gene{v: 2}, %Gene{v: 3}, %Gene{v: 4}, %Gene{v: 5}]
    count = Enum.count(genes)

    fitting =
      desired
      |> Enum.zip(genes)
      |> Enum.reduce(0, fn {x, y}, acc -> if(x == y, do: 1, else: 0) + acc end)

    fitting / count
  end

  describe "GeneticAlgorithm.find_solution/2" do
    test "finding specific pattern" do
      desired = %Chromosome{
        genes: [%Gene{v: 1}, %Gene{v: 2}, %Gene{v: 3}, %Gene{v: 4}, %Gene{v: 5}],
        fitness: 1.0
      }

      opts = [
        chrom_in_gen: 10,
        gene_values: Enum.to_list(1..5),
        length: 5,
        min_fitness: 1.0,
        mutation_chance: 0.1
      ]

      solution = GeneticAlgorithm.find_solution(&pattern_fitness/1, opts)

      Logger.info("Found solution after #{solution.generations} generations")
      assert desired in solution.most_fitting
    end
  end
end
