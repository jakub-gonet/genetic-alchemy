defmodule GeneticAlgoritmTest do
  use ExUnit.Case, async: true
  doctest GeneticAlgorithm

  def const_fitness_f(_), do: 1.0

  describe "GeneticAlgorithm.generate_initial_population/2" do
    test "0 chromosomes in population" do
      opts = [chrom_in_gen: 0]
      assert GeneticAlgorithm.generate_initial_population(&const_fitness_f/1, opts) == []
    end

    test "negative amount of chromosomes in population" do
      opts = [chrom_in_gen: -5]
      assert GeneticAlgorithm.generate_initial_population(&const_fitness_f/1, opts) == []
    end

    test "0 length chromosomes in population" do
      opts = [chrom_in_gen: 1, length: 0]

      assert GeneticAlgorithm.generate_initial_population(&const_fitness_f/1, opts) == [
               %Chromosome{genes: [], fitness: 1.0}
             ]
    end

    test "negative length of chromosomes in population" do
      opts = [chrom_in_gen: 1, length: -5]

      assert GeneticAlgorithm.generate_initial_population(&const_fitness_f/1, opts) == [
               %Chromosome{genes: [], fitness: 1.0}
             ]
    end

    test "chromosomes without values in population" do
      opts = [chrom_in_gen: 1, length: 2, gene_values: []]

      assert GeneticAlgorithm.generate_initial_population(&const_fitness_f/1, opts) == [
               %Chromosome{genes: [], fitness: 1.0}
             ]
    end
  end

  describe "GeneticAlgorithm.next_generation/3" do
    test "single element generation changes on 100% and 0% mutation chance" do
      opts = [chrom_in_gen: 1, length: 1]
      population = GeneticAlgorithm.generate_initial_population(&const_fitness_f/1, opts)

      assert GeneticAlgorithm.next_generation(
               population,
               &const_fitness_f/1,
               opts ++ [mutation_chance: 0.0]
             ) == population

      assert GeneticAlgorithm.next_generation(
               population,
               &const_fitness_f/1,
               opts ++ [mutation_chance: 1.0]
             ) != population
    end
  end
end
