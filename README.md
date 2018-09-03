# Genetic algoritm
[![Build Status](https://travis-ci.org/jakub-gonet/genetic-alchemy.svg?branch=master)](https://travis-ci.org/jakub-gonet/genetic-alchemy) [![Coverage Status](https://coveralls.io/repos/github/jakub-gonet/genetic-alchemy/badge.svg?branch=master)](https://coveralls.io/github/jakub-gonet/genetic-alchemy?branch=master)  

This is genetic algoritm implementation written in Elixir.
It uses Flow library to achieve high concurrency in time-consuming tasks such as calculating fitness or crossovering chromosomes.

Rulette select is used to select chromosomes for crossover, it's based on selecting chromosomes with chance coresponding to their fitness.

Examples of usage can be viewed [here](https://github.com/jakub-gonet/genetic-alchemy/blob/master/test/genetic_algoritm_solutions_test.exs)  
One test is finding specific gene pattern, second searches for RNP expression of given number (e.g. `2 11 *` for `22`)

## Installation
```
mix do deps.get, compile
```

### Building docs
```
mix docs
```
Built docs can be accessed in `doc/` folder or viewed online [here](https://jakub-gonet.github.io/genetic-alchemy/readme.html). 

### Running tests and code style check
```
mix test --cover && mix credo --strict
```

## Usage
```
iex -S mix
```
This command load Elixir's REPL with project modules loaded.  
Example:
```elixir
# Define fitness function:
fitness_f = fn genes ->
  desired = [%Gene{v: 1}, %Gene{v: 2}, %Gene{v: 3}, %Gene{v: 4}, %Gene{v: 5}]
    count = Enum.count(genes)

    fitting =
      desired
      |> Enum.zip(genes)
      |> Enum.reduce(0, fn {x, y}, acc -> if(x == y, do: 1, else: 0) + acc end)

    fitting / count
end

# Set algoritm options:
settings = [
  gene_values: [{Enum.to_list(1..5), 1.0}],
  length: 5,
  min_fitness: 1.0
]

# And call `GeneticAlgorithm.find_solution/2`:
GeneticAlgorithm.find_solution(fitness_f, settings)
```

Result:
```elixir
%{
  generations: 2,
  most_fitting: [
    %Chromosome{
      fitness: 1.0,
      genes: [
        %Gene{v: 1},
        %Gene{v: 2},
        %Gene{v: 3},
        %Gene{v: 4},
        %Gene{v: 5}
      ]
    }, 
    %Chromosome{
      fitness: 1.0,
      genes: [
        %Gene{v: 1}, 
        %Gene{v: 2},
        %Gene{v: 3},
        %Gene{v: 4},
        %Gene{v: 5}
      ]
    },
    %Chromosome{
      fitness: 0.8,
      genes: [
        %Gene{v: 1},
        %Gene{v: 1},
        %Gene{v: 3},
        %Gene{v: 4},
        %Gene{v: 5}
      ]
    }
  ]
}
```
