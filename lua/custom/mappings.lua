-- Key mapping
-- Navigate vim panes better
local map = vim.keymap.set

map('n', '<C-k>', ':wincmd k<CR>')
map('n', '<C-j>', ':wincmd j<CR>')
map('n', '<C-h>', ':wincmd h<CR>')
map('n', '<C-l>', ':wincmd l<CR>')

-- Fn keys
map("n", "<F3>", '<cmd>:lua ReduceLSPDiag()<CR>')
map("i", "<F3>", '<ESC><cmd>:lua ReduceLSPDiag()<CR>a')

map("n", "<F4>", ':Outline<CR>')
map("i", "<F4>", '<ESC>:Outline<CR>')

map("n", "<F5>", '<cmd>:lua RunDebug()<CR>')
map("i", "<F5>", '<ESC>:w!<CR><cmd>:lua RunDebug()<CR>')

map("n", "<F6>", ':DapToggleBreakpoint<CR>')
map("i", "<F6>", '<ESC>:DapToggleBreakpoint<CR>')

map("n", "<F7>", ':DapTerminate<CR>')
map("n", "<F8>", ':DapStepOver<CR>')

map("n", "<F9>", '<cmd>:lua Run()<CR>')
map("i", "<F9>", '<ESC>:w!<CR><cmd>:lua Run()<CR>')

map('n', '<F10>', ':w!<CR>')
map('i', '<F10>', '<ESC>:w!<CR>')

map('n', '<F12>', ':qall<CR>')
map('i', '<F12>', '<ESC>:qall<CR>')

-- Scroll reverse for MacBook only
--[[
if vim.g.neovide then
  map({'n', 'i'}, '<ScrollWheelDown>', '<ScrollWheelDown>')
  map({'n', 'i'}, '<ScrollWheelUp>', '<ScrollWheelUp>')
end
]]
-- Key mapping END


LspDiagReducedChanged = 1

function ReduceLSPDiag()
  -- Configure LSP diagnostic level
  LspDiagReducedChanged = 1
  if LspDiagReduced == 1 then
    LspDiagReduced = 0
    vim.diagnostic.config({
      virtual_text = {severity = {min = vim.diagnostic.severity.HINT}},
      signs = {severity = {min = vim.diagnostic.severity.HINT}},
      underline = {severity = {min = vim.diagnostic.severity.HINT}},
    })
  else
    LspDiagReduced = 1
    vim.diagnostic.config({
      virtual_text = {severity = {min = vim.diagnostic.severity.ERROR}},
      signs = {severity = {min = vim.diagnostic.severity.ERROR}},
      underline = {severity = {min = vim.diagnostic.severity.ERROR}},
    })
  end
end

function RunDebugPython()
  local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
  require("dap-python").setup(path)
  require("core.utils").load_mappings("dap_python")
  require('dap-python').test_method()
  --require('dap-python').debug_selection()
  --require('dap-python').test_class()
end

function RunDebug()
  if vim.bo.filetype == 'rust' then
    --vim.cmd.RustLsp('debug')
    vim.cmd.RustLsp('debuggables')
  elseif vim.bo.filetype == 'cpp' or vim.bo.filetype == 'c' then
    local bin = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local cmd = "!cp target/debug/" .. bin .. " ."
    vim.cmd('!cd target/debug ; make -j4')
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
    --vim.cmd.RustLsp('run')
    vim.cmd.RustLsp('runnables')
    --vim.cmd('!cargo run')
  elseif vim.bo.filetype == 'cpp' or vim.bo.filetype == 'c' then
    vim.cmd('!cd target/debug ; make -j4 ; ./run.sh')
  elseif vim.bo.filetype == 'python' then
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

M.nvterm = {
  plugin = true,

  t = {
    -- toggle in terminal mode
    ["<F2>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },
  },

  n = {
    -- toggle in normal mode
    ["<F2>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },
  }
}

M.general = {
  v = {
    ["<M-c>"] = { '"*y', "Copy" }, -- It's for MacOS
    ["<C-c>"] = { '"*y', "Copy" },
  },
  i = {
    ["<C-v>"] = { "<C-r>+", "Paste" },
    -- save
    ["<C-s>"] = { "<ESC>:w <CR>", "Save file" },
  },
  n = {
    ["<C-c>"] = { '"*y', "Copy" },
    ["<C-F11>"] = {
      function()
        vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
      end,
      "Toggle Fullscreen"
    },
    ["<Leader>cf"] = {
      "<cmd> echo expand('%:p') <CR>",
      "Current File Path",
    },
    -- close buffer + hide terminal buffer
    ["<C-w>"] = {
      function()
        require("nvchad.tabufline").close_buffer()
      end,
      "Close buffer",
    },
    ["<C-x>"] = { ':q<CR>', "Close Window" },
  },
}

M.nvimtree = {
  n = {
    ["<Leader>fe"] = {
      "<cmd> NvimTreeToggle <CR>",
      "NvimTreeToggle",
    },
  },
}

return M
