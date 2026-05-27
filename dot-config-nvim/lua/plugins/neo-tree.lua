return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = true,
        hide_gitignored = false,
        hide_hidden = true,
        hide_by_name = {
          ".DS_Store",
          "thumbs.db",
          ".cache",
        },
        hide_by_pattern = {},
        always_show = {
          "out",
        },
        always_show_by_pattern = {},
        never_show = {
          "lib",
          "bes2600",
          "hifi4",
          ".git",
          ".cache",
          ".repo",
        },
        never_show_by_pattern = {
          "*.xml",
          "*.gz",
          "*.log",
        },
      },
    },
  },
}
