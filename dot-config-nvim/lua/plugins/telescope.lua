return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local function find_command()
        if 1 == vim.fn.executable("fd") then
          return { "fd", "--type", "f", "--color", "never", "-E", ".git", "-E", ".cache", "-E", ".repo", "-E", "prebuilts", "-E", "*.o", "-E", "*.png", "-E", "*.d", "--hidden", "--no-ignore", "--follow" }
        elseif 1 == vim.fn.executable("fdfind") then
          return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
        elseif 1 == vim.fn.executable("rg") then
          return { "rg", "--files", "--color", "never", "-g", "!*.{png,o,der,d}", "-g", "!{prebuilts,.git,.cache,.repo,.gitignore}", "--no-ignore-vcs" }
        elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
          return { "find", ".", "-type", "f" }
        elseif 1 == vim.fn.executable("where") then
          return { "where", "/r", ".", "*" }
        end
      end

      local actions = require("telescope.actions")
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "-g", "!*.{o,png,d}",
          "-g", "!{.git,.cache,.repo,prebuilts}",
          "--no-ignore-vcs",
        },
        file_ignore_patterns = {
          "%.git/",
          "%.DS_Store",
          "thumbs%.db",
          "__pycache__/",
          "%.class$",
          "%.o$",
          "%.so$",
          "%.dylib$",
        },
        scroll_strategy = "cycle",
        mappings = {
          i = {
            ["<Tab>"] = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
          },
          n = {
            ["<Tab>"] = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
          },
        },
      })
      opts.pickers = opts.pickers or {}
      opts.pickers.find_files = {
        find_command = find_command,
        hidden = true,
        no_ignore = true,
        no_ignore_parent = true,
        follow = true,
      }
      opts.pickers.live_grep = {
        additional_args = { "--hidden", "--no-ignore" },
      }
      opts.pickers.grep_string = {
        additional_args = function()
          return { "--hidden", "--no-ignore" }
        end,
      }
      return opts
    end,
  },
}
