defmodule GeneticAlgoritmSolutionTest do
  use ExUnit.Case, async: true
  require Logger

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

  def pattern_fitness(genes) do
    desired = [%Gene{v: 1}, %Gene{v: 2}, %Gene{v: 3}, %Gene{v: 4}, %Gene{v: 5}]
    count = Enum.count(genes)

    fitting =
      desired
      |> Enum.zip(genes)
      |> Enum.reduce(0, fn {x, y}, acc -> if(x == y, do: 1, else: 0) + acc end)

    fitting / count
  end
  def compute_RPN_expr(expr), do: _compute_RPN_expr(expr, [])

  defp _compute_RPN_expr([], [result]), do: result

  defp _compute_RPN_expr([v | tail], stack) when is_number(v),
    do: _compute_RPN_expr(tail, [v | stack])

  defp _compute_RPN_expr([operator | tail], [a, b | stack])
       when is_function(operator, 2) and is_number(a) and is_number(b) do
    if operator == (&//2) and a == 0 do
      :error
    else
      _compute_RPN_expr(tail, [operator.(b, a) | stack])
    end
  end

  defp _compute_RPN_expr(_, _), do: :error
end
