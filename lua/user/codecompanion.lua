local status_ok, cc = pcall(require, "codecompanion")
if not status_ok then
  return
end

cc.setup({
  adapters = {
    http = {
      azure_openai = function()
        return require("codecompanion.adapters").extend("azure_openai", {
          env = {
            api_version = "2024-03-01-preview",
            api_key = "__BYTEDANCE_AZURE_OPENAI_API_KEY",
            endpoint = "__BYTEDANCE_AZURE_OPENAI_ENDPOINT",
          }
        })
      end
    }
  },
  strategies = {
    chat = {
      adapter = {
        name = "azure_openai",
        model = "gpt-4.1-2025-04-14",
      },
      roles = {
        user = "Me",
      },
      keymaps = {
        send = {
          modes = {
            i = { "<C-CR>" },
          },
        },
        completion = {
          modes = {
            i = "<C-x>",
          },
        },
      },
      slash_commands = {
        ["help"] = {
          opts = {
            max_lines = 1000,
          },
        },
        ["image"] = {
          opts = {
            dirs = { "~/Documents/Screenshots" },
          },
        },
      },
    },
    inline = {
      adapter = {
        name = "azure_openai",
        model = "gpt-4.1-2025-04-14",
      },
    },
  },
  display = {
    action_palette = {
      provider = "default",
    },
    chat = {
      -- show_references = true,
      -- show_header_separator = false,
      -- show_settings = false,
      icons = {
        tool_success = "󰸞 ",
      },
      fold_context = true,
      window = {
        border = "double",
        width = 80,
        opts = {
          number = false,
          winfixwidth = true,
        },
      }
    },
  },
  opts = {
    log_level = "DEBUG",
  },
}
)
