-- NOTE: Utility functions shared between progress reports for LSP and DAP
-- Credits: https://github.com/rcarriga/nvim-notify/wiki/Usage-Recipes#progress-updates

-- Attempt to load the nvim-notify plugin safely
local notify_present, _ = pcall(require, "notify")

if not notify_present then
  -- Optional: Print a message if notify is not found
  -- print("nvim-notify not found, skipping configuration.")
  return -- Exit if notify isn't available
end

local client_notifs = {}

local function get_notif_data(client_id, token)
  if not client_notifs[client_id] then
    client_notifs[client_id] = {}
  end

  if not client_notifs[client_id][token] then
    -- Initialize with a default message field
    client_notifs[client_id][token] = { message = "" }
  end

  return client_notifs[client_id][token]
end

local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

local function update_spinner(client_id, token)
  local notif_data = get_notif_data(client_id, token)

  if notif_data.spinner then
    local new_spinner = (notif_data.spinner % #spinner_frames) + 1 -- Ensure index is 1-based
    notif_data.spinner = new_spinner

    -- Retrieve the stored message for the spinner update
    local message_to_display = notif_data.message or ""

    notif_data.notification = vim.notify(message_to_display, nil, { -- Use stored message
      hide_from_history = true,
      icon = spinner_frames[new_spinner],
      replace = notif_data.notification,
      timeout = false, -- Ensure spinner updates don't timeout
    })

    vim.defer_fn(function()
      update_spinner(client_id, token)
    end, 100)
  end
end

local function format_title(title, client_name)
  return client_name .. (#title > 0 and ": " .. title or "")
end

local function format_message(message, percentage)
  return (percentage and percentage .. "%\t" or "") .. (message or "")
end

-- LSP integration
-- Make sure to also have the snippet with the common helper functions in your config!

vim.lsp.handlers["$/progress"] = function(_, result, ctx)
  local client_id = ctx.client_id
  local val = result.value

  if not val.kind then
    return
  end

  local notif_data = get_notif_data(client_id, result.token)

  if val.kind == "begin" then
    local message = format_message(val.message, val.percentage)
    notif_data.message = message -- Store the message

    notif_data.notification = vim.notify(message, nil, {
      title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
      icon = spinner_frames[1],
      timeout = false,
      hide_from_history = false,
    })

    notif_data.spinner = 1
    update_spinner(client_id, result.token)
  elseif val.kind == "report" and notif_data and notif_data.notification then
    local new_message = format_message(val.message, val.percentage)
    notif_data.message = new_message -- Update stored message

    notif_data.notification = vim.notify(new_message, nil, {
      replace = notif_data.notification,
      hide_from_history = false,
      -- Keep the spinner icon during report updates
      icon = notif_data.spinner and spinner_frames[notif_data.spinner] or nil,
    })
  elseif val.kind == "end" and notif_data and notif_data.notification then
    notif_data.notification = vim.notify(val.message and format_message(val.message) or "Complete", nil, {
      icon = "",
      replace = notif_data.notification,
      timeout = 3000,
    })

    notif_data.spinner = nil
    notif_data.message = nil -- Clear stored message
  end
end

local M = {}

-- Default settings
M.options = {
  message_start = "recording: @", -- Message for macro start
  message_end = "ended: @", -- Message for macro end
  icon_start = "󰑋", -- Icon for macro start -- TODO: not currently in use
  icon_end = "", -- Icon for macro end
}

local MACRO_CLIENT_ID = "macro"

-- Notification for macro start
function M.notify_macro_start(register)
  local token = register
  local notif_data = get_notif_data(MACRO_CLIENT_ID, token)
  local message = M.options.message_start .. register
  notif_data.message = message -- Store the message

  notif_data.notification = vim.notify(message, nil, {
    icon = spinner_frames[1],
    timeout = false,
    hide_from_history = false,
  })

  notif_data.spinner = 1
  update_spinner(MACRO_CLIENT_ID, token)
end

-- Notification for macro end (no change needed here as it stops the spinner)
function M.notify_macro_end(register)
  local token = register
  local notif_data = get_notif_data(MACRO_CLIENT_ID, token)
  local message = M.options.message_end .. register

  if notif_data and notif_data.notification then
    notif_data.notification = vim.notify(message, nil, {
      icon = M.options.icon_end,
      replace = notif_data.notification,
      timeout = 3000,
    })
    -- Stop the spinner and clear message
    notif_data.spinner = nil
    notif_data.message = nil
  else
    -- Fallback if no start notification was found
    vim.notify(message, nil, { icon = M.options.icon_end, timeout = 3000 })
  end
end

-- Set up autocommands
function M.setup(opts)
  -- Merge user settings with defaults
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
