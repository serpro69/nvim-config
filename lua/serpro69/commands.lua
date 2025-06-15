vim.api.nvim_create_user_command("ObsidianFormatAIOutput", function(opts)
  local start_line = opts.line1
  local end_line = opts.line2

  -- if opts.range is false, it means no explicit range was selected
  -- In this case, opts.line1 and opts.line2 default to the current line.
  -- We want to apply to the whole file if no explicit range was given.
  if not opts.range then
    start_line = 1
    end_line = vim.fn.line "$" -- Get the last line number
  end

  -- First substitution: Remove extra spaces after list markers
  -- Regex explanation:
  -- \v       : Very magic (makes common regex chars special, like +, ?, (, ) )
  -- ^        : Start of line
  -- (\s*     : Capture Group 1: Zero or more leading whitespace characters (for indentation)
  -- [*|-]    : Match a literal asterisk (*) or a literal hyphen (-) (common bullet list markers)
  -- |\d+\.?) : OR, match one or more digits (\d+), optionally followed by a literal dot (\.?) (for numbered lists like 1., 2.)
  -- |\w+\.?) : OR, match one or more word characters (\w+), optionally followed by a literal dot (\.?) (for alphabetical lists like a., b.)
  -- )        : End of Capture Group 1
  -- \s+      : Match one or more whitespace characters (the spaces we want to normalize)
  -- /\1 /g   : Replace with Capture Group 1 followed by a single space.
  vim.cmd(string.format("%d,%ds/\\v^(\\s*[*|-]|\\d+\\.?|\\w+\\.?)\\s+/\\1 /g", start_line, end_line))

  -- Second substitution: Prepend "> " to each line
  vim.cmd(string.format("%d,%ds/^/> /g", start_line, end_line))
end, {
  range = true, -- Crucial: tells Neovim this command accepts a range
  desc = "Format markdown output from AI for obsidian note",
})
