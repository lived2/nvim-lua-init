-- ---
-- Global
local opt = vim.opt
opt.clipboard = ""
opt.wrapscan = false
opt.scrolloff = 10

LspDiagReduced = 0
-- ---
-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
local autocmd = vim.api.nvim_create_autocmd

-- adapted from https://github.com/ethanholz/nvim-lastplace/blob/main/lua/nvim-lastplace/init.lua
local ignore_buftype = { "quickfix", "nofile", "help" }
local ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" }

local function run()
  vim.opt_local.formatoptions:remove({ 'r', 'o' })
  if vim.tbl_contains(ignore_buftype, vim.bo.buftype) then
    return
  end

  if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
    -- reset cursor to first line
    vim.cmd[[normal! gg]]
    return
  end

  -- If a line has already been specified on the command line, we are done
  --   nvim file +num
  if vim.fn.line(".") > 1 then
    return
  end

  local last_line = vim.fn.line([['"]])
  local buff_last_line = vim.fn.line("$")

  -- If the last line is set and the less than the last line in the buffer
  if last_line > 0 and last_line <= buff_last_line then
    local win_last_line = vim.fn.line("w$")
    local win_first_line = vim.fn.line("w0")
    -- Check if the last line of the buffer is the same as the win
    if win_last_line == buff_last_line then
      -- Set line to last line edited
      vim.cmd[[normal! g`"]]
      -- Try to center
    elseif buff_last_line - last_line > ((win_last_line - win_first_line) / 2) - 1 then
      vim.cmd[[normal! g`"zz]]
    else
      vim.cmd[[normal! G'"<c-e>]]
    end
  end
end

autocmd({'BufWinEnter', 'FileType'}, {
  group    = vim.api.nvim_create_augroup('nvim-lastplace', {}),
  callback = run
})

autocmd('BufEnter', {
  callback = function()
    if vim.bo.filetype == "rust" or vim.bo.filetype == "cpp" then
      opt.shiftwidth = 4
      opt.tabstop = 4
      opt.softtabstop = 4
    else
      opt.shiftwidth = 2
      opt.tabstop = 2
      opt.softtabstop = 2
    end

    local extension = vim.fn.expand('%:e')
    if vim.bo.filetype == "text" or extension == "log" or extension == "dump" or extension == "lst" then
      require('cmp').setup.buffer { enabled = false }
    end
    -- Change tab size for specific path
    --[[
    local path = vim.fn.getcwd()
    if string.find(path, "qcom") then
      opt.shiftwidth = 2
      opt.tabstop = 2
      opt.softtabstop = 2
    end
    --]]
  end
})

autocmd('BufReadPost', {
  --group = vim.g.user.event,
  callback = function()
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
    print(vim.fn.expand('%:p'))
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
  local os = vim.loop.os_uname().sysname
  if os == "Windows_NT" then
    vim.o.guifont = "JetBrainsMono Nerd Font:h10"
  else
    vim.o.guifont = "JetBrainsMono Nerd Font:h13"
  end
else
  vim.o.guifont = "JetBrainsMono Nerd Font:h13"
end
