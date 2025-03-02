-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'hoob3rt/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          theme = 'catppuccin',
          icons_enabled = true,

          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }
    end,
  },
  { 'tpope/vim-fugitive' },
  {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('flutter-tools').setup {
        ui = {
          -- the border type to use for all floating windows, the same options/formats
          -- used for ":h nvim_open_win" e.g. "single" | "shadow" | {<table-of-eight-chars>}
          border = 'rounded',
          -- This determines whether notifications are show with `vim.notify` or with the plugin's custom UI
          -- please note that this option is eventually going to be deprecated and users will need to
          -- depend on plugins like `nvim-notify` instead.
        },
        decorations = {
          statusline = {
            -- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
            -- this will show the current version of the flutter app from the pubspec.yaml file
            app_version = false,
            -- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
            -- this will show the currently running device if an application was started with a specific
            -- device
            device = true,
            -- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
            -- this will show the currently selected project configuration
            project_config = false,
          },
        },
        debugger = { -- integrate with nvim dap + install dart code debugger
          enabled = false,
          -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
          -- see |:help dap.set_exception_breakpoints()| for more info
          exception_breakpoints = {},
          -- Whether to call toString() on objects in debug views like hovers and the
          -- variables list.
          -- Invoking toString() has a performance cost and may introduce side-effects,
          -- although users may expected this functionality. null is treated like false.
          evaluate_to_string_in_debug_views = true,
          register_configurations = function(paths)
            require('dap').configurations.dart = {
              --put here config that you would find in .vscode/launch.json
            }
            -- If you want to load .vscode launch.json automatically run the following:
            -- require("dap.ext.vscode").load_launchjs()
          end,
        },
        dev_log = {
          enabled = true,
          filter = nil, -- optional callback to filter the log
          -- takes a log_line as string argument; returns a boolean or nil;
          -- the log_line is only added to the output if the function returns true
          notify_errors = false, -- if there is an error whilst running then notify the user
          open_cmd = '15split', -- command to use to open the log buffer
          focus_on_open = true, -- focus on the newly opened log window
        },
      }
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = '[a]dd to harpoon list' })
      vim.keymap.set('n', '<leader>re', function()
        harpoon:list():remove()
      end, { desc = '[r]emove from harpoon list' })
      vim.keymap.set('n', '<leader>hc', function()
        harpoon:list():clear()
      end, { desc = '[c]lear harpoon list' })
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'open harpoon list' })

      vim.keymap.set('n', '<C-h>', function()
        harpoon:list():select(1)
      end, { desc = 'open first harpoon file' })
      vim.keymap.set('n', '<C-t>', function()
        harpoon:list():select(2)
      end, { desc = 'open second harpoon file' })
      vim.keymap.set('n', '<C-n>', function()
        harpoon:list():select(3)
      end, { desc = 'open third harpoon file' })
      vim.keymap.set('n', '<C-s>', function()
        harpoon:list():select(4)
      end, { desc = 'open fourth harpoon file' })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-S-P>', function()
        harpoon:list():prev()
      end, { desc = 'go to [p]revious harpoon file' })
      vim.keymap.set('n', '<C-S-N>', function()
        harpoon:list():next()
      end, { desc = 'go to [n]ext harpoon file' })
      -- basic telescope configuration
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<C-e>', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })
    end,
  },
}
