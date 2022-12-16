defmodule Servy.BearView do
  require EEx

  # Mix *always* runs from the project's root directory.
  @root "templates"

  EEx.function_from_file(:def, :index, Path.join(@root, "index.eex"), [:bears])
  EEx.function_from_file(:def, :show, Path.join(@root, "show.eex"), [:bear])
end
