defmodule GeneticTest do
  use ExUnit.Case
  doctest Genetic

  describe "Genetic.populate/3" do
    test "create population" do
      assert Genetic.populate(2, 1..1, 2) == [
               %Chromosome{genes: [1, 1]},
               %Chromosome{genes: [1, 1]}
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
end
