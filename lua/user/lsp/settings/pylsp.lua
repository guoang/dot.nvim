return {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          maxLineLength = 120,
        },
        mccabe = {
          enabled = false,
        },
        rope_autoimport = {
          enabled = false,
        }
      },
    },
  },
}
