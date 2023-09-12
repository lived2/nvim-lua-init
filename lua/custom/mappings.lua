-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

-- Fn keys
vim.keymap.set("n", "<F5>", '<cmd>:lua RunDebug()<CR>')
vim.keymap.set("i", "<F5>", '<ESC><cmd>:lua RunDebug()<CR>')
vim.keymap.set("n", "<F6>", ':DapToggleBreakpoint<CR>')
vim.keymap.set("i", "<F6>", '<ESC>:DapToggleBreakpoint<CR>')
vim.keymap.set("n", "<F7>", ':DapTerminate<CR>')
vim.keymap.set("n", "<F8>", ':DapStepOver<CR>')

vim.keymap.set("n", "<F9>", '<cmd>:lua Run()<CR>')
vim.keymap.set("i", "<F9>", '<ESC><cmd>:lua Run()<CR>')

vim.keymap.set('n', '<F10>', ':w!<CR>')
vim.keymap.set('i', '<F10>', '<ESC>:w!<CR>')
vim.keymap.set('n', '<F12>', ':qall<CR>')
vim.keymap.set('i', '<F12>', '<ESC>:qall<CR>')


function RunDebug()
  if vim.bo.filetype == 'rust' then
    vim.cmd('RustDebuggable')
  end
end

function Run()
  if vim.bo.filetype == 'rust' then
    vim.cmd('RustRunnables')
  end
end

local M = {}

M.crates = {
  plugin = true,
  n = {
    ["<Leader>rcu"] = {
      function ()
        require('crates').upgrade_all_crates()
      end,
      "Update crates"
    }
  }
}

return M
