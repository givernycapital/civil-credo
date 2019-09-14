defmodule CivilCredo do
  @moduledoc """
  CivilCode's in-house rules.
  """

  @config_file File.read!(".credo.exs")

  import Credo.Plugin

  def init(exec) do
    register_default_config(exec, @config_file)
  end
end
