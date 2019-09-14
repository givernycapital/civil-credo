%{
  configs: [
    %{
      name: "default",
      checks: [
        {CivilCredo.Check.Design.TagWip, []}
      ]
    }
  ]
}
