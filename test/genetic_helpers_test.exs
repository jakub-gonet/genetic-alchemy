defmodule GeneticAlgoritm.HelpersTest do
  use ExUnit.Case, async: true
  alias GeneticAlgorithm.Helpers
  doctest GeneticAlgorithm.Helpers

  @template_population [
    %Chromosome{genes: [%Gene{v: 1}, %Gene{v: 2}, %Gene{v: 3}], fitness: 1.0},
    %Chromosome{genes: [%Gene{v: 10}, %Gene{v: 20}, %Gene{v: 30}], fitness: 1.0},
    %Chromosome{genes: [%Gene{v: 100}, %Gene{v: 200}, %Gene{v: 300}], fitness: 1.0}
  ]
  @default_allowed_values [{[0], 1.0}]

  def const_fitness_f(_), do: 1.0

  describe "GeneticAlgorithm.Helpers.populate/3" do
    test "create population" do
      assert Helpers.populate(2, @default_allowed_values, 2, &const_fitness_f/1) == [
               %Chromosome{genes: [%Gene{v: 0}, %Gene{v: 0}], fitness: 1.0},
               %Chromosome{genes: [%Gene{v: 0}, %Gene{v: 0}], fitness: 1.0}
             ]
    end

    test "create population with 0 chromosomes" do
      assert Helpers.populate(0, @default_allowed_values, 2, &const_fitness_f/1) == []
    end

    test "create population with negative amount of chromosomes or chromosomes length" do
      assert Helpers.populate(-5, @default_allowed_values, 2, &const_fitness_f/1) == []

      assert Helpers.populate(2, @default_allowed_values, -2, &const_fitness_f/1) == [
               %Chromosome{fitness: 1.0, genes: []},
               %Chromosome{fitness: 1.0, genes: []}
             ]
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

      first_gen_data = merge_and_sort_chromosome_values.(@template_population)

      second_gen_data =
        @template_population
        |> Helpers.crossover(&const_fitness_f/1)
        |> merge_and_sort_chromosome_values.()

      assert Enum.all?(second_gen_data, &Enum.member?(first_gen_data, &1))
    end

    test "population with one member remains unchanged" do
      population = [%Chromosome{genes: [%Gene{v: 1}, %Gene{v: 2}, %Gene{v: 3}], fitness: 1.0}]
      assert Helpers.crossover(population, &const_fitness_f/1) == population
    end
  end

  describe "GeneticAlgorithm.Helpers.mutate/3" do
    test "0% chance doesn't change any chromosome" do
      assert Helpers.mutate(
               @template_population,
               @default_allowed_values,
               0,
               &const_fitness_f/1
             ) == @template_population
    end

    test "100% chance always change every chromosome" do
      assert @template_population
             |> Helpers.mutate(@default_allowed_values, 1, &const_fitness_f/1)
             |> Enum.map(& &1.genes)
             |> Enum.all?(&(%Gene{v: 0} in &1))
    end
  end

  describe "GeneticAlgorithm.Helpers.select_most_fitting/3" do
    test "const fitness takes any n chromosomes" do
      assert @template_population
             |> Helpers.select_most_fitting(3)
             |> Enum.all?(&(&1 in @template_population))
    end
  end
end
