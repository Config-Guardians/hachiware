defmodule Hachiware.Provider.Github.RepositoryContent.Selector do
  @behaviour Hachiware.Provider.WatchedResource

  def diff_attribute(%Hachiware.Provider.Github.RepositoryContent{content: content}), do: content

  def entry_id(%Hachiware.Provider.Github.RepositoryContent{path: path}), do: path
end
