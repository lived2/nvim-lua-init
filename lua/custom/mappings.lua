-- Navigate vim panes better
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>')

-- Fn keys
vim.keymap.set("n", "<F3>", ':ToggleDiag<CR>')
vim.keymap.set("i", "<F3>", '<ESC>:ToggleDiag<CR>a')

vim.keymap.set("n", "<F4>", ':SymbolsOutline<CR>')
vim.keymap.set("i", "<F4>", '<ESC>:SymbolsOutline<CR>')

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

-- Ctrl + S: save
vim.keymap.set('n', '<C-s>', ':w!<CR>')
vim.keymap.set('i', '<C-s>', '<ESC>:w!<CR>')


function RunDebugPython()
  require('dap-python').test_method()
end

function RunDebug()
  if vim.bo.filetype == 'rust' then
    vim.cmd('RustDebuggable')
  elseif vim.bo.filetype == 'cpp' or vim.bo.filetype == 'c' then
    local bin = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local cmd = "!cp build/debug/" .. bin .. " ."
    vim.cmd('w')
    vim.cmd('!cd build/debug ; make -j4')
    vim.cmd(cmd)
    vim.cmd('DapContinue')
  elseif vim.bo.filetype == 'python' then
    RunDebugPython()
  else
    vim.cmd('DapContinue')
  end
end

function Run()
  if vim.bo.filetype == 'rust' then
    vim.cmd('RustRunnables')
  elseif vim.bo.filetype == 'cpp' or vim.bo.filetype == 'c' then
    vim.cmd('w!')
    vim.cmd('!cd build/debug ; make -j4 ; ./run.sh')
  elseif vim.bo.filetype == 'python' then
    vim.cmd('w!')
    vim.cmd('!python3 %')
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

M.dap = {
  plugin = true,
  n = {
    ["<Leader>dt"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line",
    },
    ["<Leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Start or continue the debugger",
    },
    ["<Leader>dx"] = {
      "<cmd> DapTerminate <CR>",
      "Terminate the debugger",
    },
    ["<Leader>do"] = {
      "<cmd> DapStepOver <CR>",
      "Step Over",
    },
    ["<Leader>di"] = {
      "<cmd> DapStepInto <CR>",
      "Step Into",
    },
    ["<Leader>du"] = {
      "<cmd> DapStepOut <CR>",
      "Step Out",
    },
  }
}

M.dap_python = {
  plugin = true,
  n = {
    ["<Leader>dpr"] = {
      function()
        require('dap-python').test_method()
      end
    }
  }
}

return M
