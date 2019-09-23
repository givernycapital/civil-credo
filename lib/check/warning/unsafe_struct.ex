defmodule CivilCredo.Check.Warning.UnsafeStruct do
  @moduledoc """
  Checks for calls to Kernel.struct/2

  Kernel.struct/2 builds a struct without checking that all the required keys
  are present, and is therefore unsafe.  Kernel.struct!/2 performs this check and so is
  the preferred form.
  """

  @explanation [ check: @moduledoc ]

  use Credo.Check, base_priority: :high, category: :warning, exit_status: 2

  @doc false
  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

  defp traverse( { :struct, meta , _args } = ast, issues, issue_meta ) do
    {ast, issues_for_call(meta, issues, issue_meta)}
  end

  defp traverse(ast, issues, _issue_meta) do
    {ast, issues}
  end

  defp issues_for_call(meta, issues, issue_meta) do
    [issue_for(issue_meta, meta[:line]) | issues]
  end

  @message "Use of struct/2 does not ensure all keys are provided (struct!/2 is preferred)"
  @trigger "struct"

  defp issue_for(issue_meta, line_no) do
    format_issue(
      issue_meta,
      message: @message,
      trigger: @trigger,
      line_no: line_no
    )
  end
end
