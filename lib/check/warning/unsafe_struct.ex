defmodule CivilCredo.Check.Warning.UnsafeStruct do
  @moduledoc """
  Checks for calls to Kernel.struct/2

  Kernel.struct/2 builds a struct without checking that all the required keys
  are present, and is therefore unsafe.  Kernel.struct!/2 performs this check and so is
  the preferred form.
  """

  @explanation [check: @moduledoc]

  use Credo.Check, base_priority: :high, category: :warning

  @doc false
  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

  # Exclude 'struct' as function param or local
  defp traverse({:struct, _meta, args} = ast, issues, _issue_meta) when is_nil(args) do
    {ast, issues}
  end

  # Exclude `Ecto.Query.struct(source, fields)`
  defp traverse(
         {:struct, _meta, [_arg1, [arg2_head | _arg2_tail] = _arg2]} = ast,
         issues,
         _issue_meta
       )
       when is_atom(arg2_head) do
    {ast, issues}
  end

  # Include Kernel.struct/2
  defp traverse({:struct, meta, _args} = ast, issues, issue_meta) do
    {ast, issues_for_call(meta, issues, issue_meta)}
  end

  # Exclude everything else
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
