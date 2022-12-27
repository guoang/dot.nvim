local status_ok, lightspeed = pcall(require, "lightspeed")
if not status_ok then
  return
end

lightspeed.setup {
  ignore_case = false,
  -- These keys are captured directly by the plugin at runtime.
  special_keys = {
    next_match_group = '<tab>',
    prev_match_group = '<S-tab>',
  },
}
