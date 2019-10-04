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
      # 1. Configure the plugin
      plugins: [
        {CivilCredo, []}
      ]
    }
  ]
  checks: [
    # 2. Add this after existing checks
    # Custom checks from Plugin
    #
    {CivilCredo.Check.Design.TagWip, []},
    {CivilCredo.Check.Warning.UnsafeStruct, []}
  ]
}
```
