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
        issue.message ==
          "Use of struct/2 does not ensure all keys are provided (struct!/2 is preferred)"
        && issue.exit_status == 2
      end)
    end

    test "finds calls to struct/2 in a pipeline" do
      string = """
        defmodule Foo do
          defstruct :bar

          def build(bar) do
            __MODULE__
            |> struct(bar: bar)
          end
        end
      """

      string
      |> to_source_file
      |> assert_issue(@described_check, fn issue ->
        issue.message ==
          "Use of struct/2 does not ensure all keys are provided (struct!/2 is preferred)"
        && issue.exit_status == 2
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

    test "allows 'struct' as a param name" do
      string = """
        defmodule Foo do
          def build(struct) do
            struct = Map.put(struct, :foo, :bar)
          end
        end
      """

      string
      |> to_source_file
      |> refute_issues(@described_check)
    end

    test "allows 'struct' as a local on the left side of a match" do
      string = """
        defmodule Foo do
          def build() do
            struct = :bar
          end
        end
      """

      string
      |> to_source_file
      |> refute_issues(@described_check)
    end

    test "allows 'struct' as a parameter in a function call" do
      string = """
        defmodule Foo do
          def build() do
            struct = :bar
            foo = baz(struct)
          end
        end
      """

      string
      |> to_source_file
      |> refute_issues(@described_check)
    end

    test "allows 'struct' as a local at the start of a pipeline" do
      string = """
        defmodule Foo do
          def build() do
            struct = :bar
            struct |> foo()
          end
        end
      """

      string
      |> to_source_file
      |> refute_issues(@described_check)
    end

    test "allows 'struct' in an ecto query" do
      string = """
        defmodule Foo do
          def build() do
            from p in Post,
              select: struct(p, [:title, :body])
          end
        end
      """

      string
      |> to_source_file
      |> refute_issues(@described_check)
    end
  end
end
