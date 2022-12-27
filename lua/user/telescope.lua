local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-h>"] = actions.which_key,
        ["<Down>"] = actions.cycle_history_next,
        ["<Up>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-f>"] = actions.preview_scrolling_down,
        ["<C-b>"] = actions.preview_scrolling_up,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--ignore", "-L", "--files" },
      -- find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
    },
  },
  preview = {
    mime_hook = function(filepath, bufnr, opts)
      local is_image = function(filepath)
        local image_extensions = {'png','jpg'}   -- Supported image formats
        local split_path = vim.split(filepath:lower(), '.', {plain=true})
        local extension = split_path[#split_path]
        return vim.tbl_contains(image_extensions, extension)
      end
      if is_image(filepath) then
        local term = vim.api.nvim_open_term(bufnr, {})
        local function send_output(_, data, _ )
          for _, d in ipairs(data) do
            vim.api.nvim_chan_send(term, d..'\r\n')
          end
        end
        vim.fn.jobstart(
          {
            'catimg', filepath  -- Terminal image viewer command
          }, 
          {on_stdout=send_output, stdout_buffered=true})
      else
        require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
      end
    end
  },
}

telescope.load_extension('projects')
telescope.load_extension('fzf')
