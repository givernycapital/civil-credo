# CivilCredo

CivilCode's in-house Credo rules.

## Installation

To your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:civil_credo, github: "civilcode/civil-credo", only: [:dev, :test], runtime: false},
  ]
end
```

and `.credo.exs`.

```elixir
%{
  configs: [
    %{
      name: "default",
      plugins: [
        {CivilCredo, []}
      ]
    }
  ]
}
```
