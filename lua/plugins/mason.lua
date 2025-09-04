return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"emmet_ls",
				"pyright",
				"gopls",
				"jsonls",
				"yamlls",
				"bashls",
				"jdtls",
			},
		})

		mason_tool_installer.setup({
			ensure_installer = {
				"prettier",
				"stylua",
				"isort",
				"black",
				"pylint",
				"eslint_d",
				"gofumpt",
				"goimports",
				"golines",
				"golangci-lint",
				"shfmt",
				-- Java tools
				"java-debug-adapter",
				"java-test",
				"google-java-format",
			},
		})
	end,
}
