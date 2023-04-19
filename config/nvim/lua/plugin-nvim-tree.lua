return function()
  local nvim_tree = require("nvim-tree")

  nvim_tree.setup({
    -- 不显示 git 状态图标
    git = {
      enable = false,
    },
    sort_by = "case_sensitive",
    -- project plugin 需要这样设置
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    renderer = {
      group_empty = true,
    },
    -- 隐藏 .文件 和 node_modules 文件夹
    filters = {
      dotfiles = true,
    },
    view = {
      -- 宽度
      width = 24,
      -- 也可以 'right'
      side = "left",
      -- 隐藏根目录
      hide_root_folder = false,
      adaptive_size = true,
      -- 不显示行数
      number = false,
      relativenumber = false,
      -- 显示图标
      signcolumn = "yes",
    },
    actions = {
      open_file = {
        -- 首次打开大小适配
        resize_window = true,
      },
    },
    system_open = {
      cmd = "open", -- mac 直接设置为 open
    },
  })
end
