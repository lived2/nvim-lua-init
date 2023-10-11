-- ---
-- Global
local opt = vim.opt
opt.clipboard = ""

LspDiagReduced = 0
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
    elseif vim.bo.filetype == "rust" or vim.bo.filetype == "cpp" then
      opt.shiftwidth = 4
      opt.tabstop = 4
      opt.softtabstop = 4
    else
      opt.shiftwidth = 2
      opt.tabstop = 2
      opt.softtabstop = 2
    end
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) <= vim.fn.line('$')

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

local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  if not directory and not no_name then
    return
  end

  if directory then
    -- change to the directory
    vim.cmd.cd(data.file)
  end

  -- open the tree
  require("nvim-tree.api").tree.open()
end
autocmd('VimEnter', { callback = open_nvim_tree })

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  vim.o.guifont = "JetBrainsMono Nerd Font:h13"
end
