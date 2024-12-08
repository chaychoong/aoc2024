# Aoc2024

## Quickstart

The fastest way to get started on this repo is to [install
Elixir](https://elixir-lang.org/install.html), and run the following:

```bash
# Get all the dependencies
mix deps.get

# Run all tests
mix test

# Run tests for a specific day/part, e.g. Day 1 Part 1
mix test --only day1p1
```

## Repo structure

This repo is created using `mix new aoc2024`, and borrows some of the toolings I
made for last year's challenge.

Each `lib/days/dayXX.ex` file uses the `Aoc.Utils.Test` macro, which injects the following functions:

* `solve_example_partX`: runs `solution_partX` against `@example`, and check if
  the output is equal to `@example_partX`

* `solve_partX`: runs `solution_partX` against an input file

This introduces a couple of expectations:

* `dayXX.ex` files must contain module attributes `@example` and
  `@example_partX` 

* `dayXX.ex` files must contain `solution_partX` functions

The main test file is located at `aoc2024_test.exs`.

## Workflows

### New day

When a new challenge drops:

* Create a new `dayXX.ex` file and copy the contents from `template.ex`

* Bump the upper range of `day <- 1..X` in `aoc2024_test.exs`

### Troubleshooting with `iex`

Run `iex -S mix` to launch an interactive shell.

```bash
> iex -S mix
iex(1)> Aoc.DayXX.test()
....

iex(1)> recompile()
iex(1)> Aoc.DayXX.test()
```

Whenever there's a code change, run `recompile()` to update the session. Use
`dbg()` and `throw()` instead of `IO.puts` to get richer information about the
state of the code.

### Troubleshooting with livebook

This is my personal favourite way. Instead of `iex -S mix`, use:

```bash
iex --name test@127.0.0.1 --cookie mycookie -S mix
```

Then do the following:

* Open [livebook](https://livebook.dev/) - install it if you haven't

* Create a new notebook

* Click on the `Runtime settings` on the left sidebar

* Click on `Configure` and select `Attached node`

* Enter the connection info - for the above example, it should be
  `test@127.0.0.1` and `mycookie` for the cookie

The notebook will now be connected to the iex session and can run code from this
repo. 

Note that it is not possible to install dependencies from the notebook. For
convenience, the `kino` dependency is included in this notebook, which enables
visualising `dbg()` pipelines.
