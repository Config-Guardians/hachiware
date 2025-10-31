defprotocol Hachiware.Poller.Runner.Diff do
  @spec entry_id(struct()) :: term()
  def entry_id(val)
  @spec diff_attribute(struct()) :: term()
  def diff_attribute(val)
end
