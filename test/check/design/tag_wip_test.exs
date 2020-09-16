defmodule CivilCredo.Check.Design.TagWipTest do
  use Credo.TestHelper

  @described_check CivilCredo.Check.Design.TagWip

  describe "tag wip" do
    test "finds tag wip" do
      string = """
        defmodule TestModule do
            @tag :wip
            def hello(), do: :world
        end
      """

      string
      |> to_source_file
      |> assert_issue(@described_check, fn issue ->
        issue.message == "This test has been tagged with WIP"
        && issue.exit_status == 2
      end)
    end
  end
end
