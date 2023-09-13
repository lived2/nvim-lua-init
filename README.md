# nvim-lua-init
1. NVChad first (https://nvchad.com/docs/quickstart/install)
   git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim  
  
2. Mason Install
   MasonInstall rust-analyzer
   MasonInstall codelldb

3. If codelldb is failed to launch with exit code 1 due to port missing,
   Add below lines to "custom/rust_config.lua"
   rt.setup({
   dap = {  
    adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),  
   + adapter = {  
   +   port = 32000  
   + }  
  },  

   
   
   
