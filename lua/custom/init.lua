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
    end
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')

    if valid_line then
      vim.cmd([[normal! g`"]])
    end
  end,
})

local opt = vim.opt
opt.clipboard = ""
