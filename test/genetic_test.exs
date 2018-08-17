defmodule GeneticTest do
  use ExUnit.Case, async: true
  doctest Genetic

  describe "Genetic.populate/3" do
    test "create population" do
      assert Genetic.populate(2, 1..1, 2) == [
               %Chromosome{genes: [%Gene{v: 1}, %Gene{v: 1}]},
               %Chromosome{genes: [%Gene{v: 1}, %Gene{v: 1}]}
             ]
    end

    test "create population with 0 chromosomes" do
      assert Genetic.populate(0, 1..1, 2) == []
    end

    test "create population with negative amount of chromosomes or chromosomes length" do
      assert Genetic.populate(-5, 1..1, 2) == []
      assert Genetic.populate(2, 1..1, -2) == []
    end
  end

  describe "Genetic.crossover/1" do
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
        |> Genetic.crossover()
        |> merge_and_sort_chromosome_values.()

      assert first_gen_data == second_gen_data
    end

    test "population with one member remains unchanged" do
      population = [%Chromosome{genes: [%Gene{v: 1}, %Gene{v: 2}, %Gene{v: 3}]}]
      assert Genetic.crossover(population) == population
    end
  end
end
