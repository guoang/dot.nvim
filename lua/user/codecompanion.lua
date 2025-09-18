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
          },
          schema = {
            model = {
              default = "gpt-5-2025-08-07",
              -- default = "gpt-4.1-2025-04-14",
            },
            -- gpt-5 is a reasoning model no need to worry about the temperature
            -- temperature = {
            --   default = 0.2,
            -- },
            max_tokens = {
              default = 16384,
            },
          }
        })
      end
    }
  },
  strategies = {
    chat = {
      adapter = {
        name = "azure_openai",
        model = "gpt-5-2025-08-07",

        -- name = "copilot",
        -- model = "gpt-5",
      },
      roles = {
        user = "👤 Me",
        llm = function(adapter)
          return "🤖 CodeCompanion (" .. adapter.formatted_name .. ")"
        end
      },
      keymaps = {
        send = {
          modes = {
            i = { "<C-CR>" },
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
        model = "gpt-5-2025-08-07",

        -- name = "copilot",
        -- model = "gpt-5",
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
