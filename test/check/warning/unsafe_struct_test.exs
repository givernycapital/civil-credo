defmodule CivilCredo.Check.Warning.UnsafeStructTest do
  use Credo.TestHelper

  @described_check CivilCredo.Check.Warning.UnsafeStruct

  describe "finding calls to struct/2" do
    test "finds calls to struct/2" do
      string = """
        defmodule Foo do
          defstruct :bar

          def build(bar) do
            struct(__MODULE__, bar: bar)
          end
        end
      """

      string
      |> to_source_file
      |> assert_issue(@described_check, fn issue ->
        issue.message == "Use of struct/2 does not ensure all keys are provided (struct!/2 is preferred)"
      end)
    end

    test "allows calls to struct!/2" do
      string = """
        defmodule Foo do
          defstruct :bar

          def build(bar) do
            struct!(__MODULE__, bar: bar)
          end
        end
      """

      string
      |> to_source_file
      |> refute_issues(@described_check)
    end
  end
end
