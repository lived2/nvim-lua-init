-- ---
-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
local autocmd = vim.api.nvim_create_autocmd

autocmd('BufEnter', {
  --group = vim.g.user.event,
  callback = function()
    if vim.bo.filetype == "gitcommit" then
      return
    elseif vim.bo.filetype == "rust" then
      local opt = vim.opt
      opt.shiftwidth = 4
      opt.tabstop = 4
      opt.softtabstop = 4
    else
      local opt = vim.opt
      opt.shiftwidth = 2
      opt.tabstop = 2
      opt.softtabstop = 2
    end
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')

    if valid_line then
      vim.cmd([[normal! g`"]])
    end

    if LspDiagReducedChanged == 1 then
      LspDiagReducedChanged = 0
      if LspDiagReduced == 0 then
        vim.diagnostic.config({
          virtual_text = {severity = {min = vim.diagnostic.severity.HINT}},
          signs = {severity = {min = vim.diagnostic.severity.HINT}},
          underline = {severity = {min = vim.diagnostic.severity.HINT}},
        })
      else
        vim.diagnostic.config({
          virtual_text = {severity = {min = vim.diagnostic.severity.ERROR}},
          signs = {severity = {min = vim.diagnostic.severity.ERROR}},
          underline = {severity = {min = vim.diagnostic.severity.ERROR}},
        })
      end
    end
  end,
})

local opt = vim.opt
opt.clipboard = ""

LspDiagReduced = 1
