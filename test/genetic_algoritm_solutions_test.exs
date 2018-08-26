defmodule GeneticAlgoritmSolutionTest do
  # credo:disable-for-this-file Credo.Check.Consistency.SpaceAroundOperators
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

      Logger.info("Found solution for pattern problem after #{solution.generations} generations")
      assert desired in solution.most_fitting
    end

    test "find math operation evaluating to given number" do
      opts = [
        chrom_in_gen: 100,
        gene_values: Enum.to_list(1..25) ++ [&+/2, &-/2, &*/2, &//2],
        length: 3,
        min_fitness: 1.0,
        mutation_chance: 0.2
      ]

      solution = GeneticAlgorithm.find_solution(&reverse_calculator_fitness/1, opts)
      best = Enum.at(solution.most_fitting, 0)

      Logger.info(
        "Found solution for reverse calculating 42 after #{solution.generations} generations,
        genes: #{inspect(best.genes)}"
      )

      assert 42 == best.genes |> Enum.map(& &1.v) |> compute_RPN_expr()
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

  def reverse_calculator_fitness(genes) do
    num_diff = fn
      :error, _ ->
        0.0

      v, wanted ->
        diff = abs((wanted - v) / wanted)
        cut_range = if diff > 1.0, do: 1.0, else: diff
        1.0 - cut_range
    end

    genes
    |> Enum.map(& &1.v)
    |> compute_RPN_expr()
    |> num_diff.(42)
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
