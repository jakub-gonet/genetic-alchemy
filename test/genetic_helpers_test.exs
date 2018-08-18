defmodule GeneticHelpersTest do
  use ExUnit.Case, async: true
  alias GeneticAlgorithm.Helpers
  doctest GeneticAlgorithm.Helpers

  describe "GeneticAlgorithm.Helpers.populate/3" do
    test "create population" do
      assert Helpers.populate(2, 1..1, 2) == [
               %Chromosome{genes: [%Gene{v: 1}, %Gene{v: 1}]},
               %Chromosome{genes: [%Gene{v: 1}, %Gene{v: 1}]}
             ]
    end

    test "create population with 0 chromosomes" do
      assert Helpers.populate(0, 1..1, 2) == []
    end

    test "create population with negative amount of chromosomes or chromosomes length" do
      assert Helpers.populate(-5, 1..1, 2) == []
      assert Helpers.populate(2, 1..1, -2) == []
    end
  end

  describe "GeneticAlgorithm.Helpers.crossover/1" do
    test "crossovered population contains data from previous population" do
      merge_and_sort_chromosome_values = fn chrom ->
        chrom
        |> Enum.map(& &1.genes)
        |> Enum.reduce(&++/2)
        |> Enum.sort()
      end

      population = [
        %Chromosome{genes: [%Gene{v: 1}, %Gene{v: 2}, %Gene{v: 3}]},
        %Chromosome{genes: [%Gene{v: 10}, %Gene{v: 20}, %Gene{v: 30}]},
        %Chromosome{genes: [%Gene{v: 100}, %Gene{v: 200}, %Gene{v: 300}]}
      ]

      first_gen_data = merge_and_sort_chromosome_values.(population)

      second_gen_data =
        population
        |> Helpers.crossover()
        |> merge_and_sort_chromosome_values.()

      assert first_gen_data == second_gen_data
    end

    test "population with one member remains unchanged" do
      population = [%Chromosome{genes: [%Gene{v: 1}, %Gene{v: 2}, %Gene{v: 3}]}]
      assert Helpers.crossover(population) == population
    end
  end

  describe "GeneticAlgorithm.Helpers.mutate/3" do
    test "0% chance doesn't change any chromosome" do
      population = [
        %Chromosome{genes: [%Gene{v: 1}, %Gene{v: 2}, %Gene{v: 3}]},
        %Chromosome{genes: [%Gene{v: 10}, %Gene{v: 20}, %Gene{v: 30}]},
        %Chromosome{genes: [%Gene{v: 100}, %Gene{v: 200}, %Gene{v: 300}]}
      ]

      assert Helpers.mutate(population, [1], 0) == population
    end

    test "100% chance always change every chromosome" do
      population = [
        %Chromosome{genes: [%Gene{v: 1}, %Gene{v: 2}, %Gene{v: 3}]},
        %Chromosome{genes: [%Gene{v: 10}, %Gene{v: 20}, %Gene{v: 30}]},
        %Chromosome{genes: [%Gene{v: 100}, %Gene{v: 200}, %Gene{v: 300}]}
      ]

      assert population
             |> Helpers.mutate([0], 1)
             |> Enum.map(& &1.genes)
             |> Enum.all?(&(%Gene{v: 0} in &1))
    end
  end

  describe "GeneticAlgorithm.Helpers.select_most_fitting/3" do
    test "const fitness takes any n chromosomes" do
      population = [
        %Chromosome{genes: [%Gene{v: 1}, %Gene{v: 2}, %Gene{v: 3}]},
        %Chromosome{genes: [%Gene{v: 10}, %Gene{v: 20}, %Gene{v: 30}]},
        %Chromosome{genes: [%Gene{v: 100}, %Gene{v: 200}, %Gene{v: 300}]}
      ]

      assert population
             |> Helpers.select_most_fitting(3, fn x -> 0 end)
             |> Enum.all?(&(&1 in population))
    end
  end
end
