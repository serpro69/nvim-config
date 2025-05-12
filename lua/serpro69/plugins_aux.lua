-- NOTE: plugin extras
local M = {}

M.ai_models = {
  -- https://ai.google.dev/gemini-api/docs/models
  copilot = {
    claude_sonnet = "claude-3.7-sonnet",
    gemini_pro = "gemeni-2.5-pro",
    gemini_flash = "gemeni-2.5-flash",
  },
  gemini = {
    flash = "gemini-2.5-flash-preview-04-17",
    pro = "gemini-2.5-pro-preview-05-06",
  },
}

return M
