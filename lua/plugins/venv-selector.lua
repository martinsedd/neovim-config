return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
		"mfussenegger/nvim-dap-python",
	},
	branch = "regexp",
	opts = {
		options = {
			enable_cached_venvs = true,
			cached_venv_automatic_activation = true,
			activate_venv_in_terminal = true,
		},
		search = {
			poetry = {
				command = "fd '/bin/python$' ~/.cache/pypoetry/virtualenvs --full-path",
			},
		},
	},
}
