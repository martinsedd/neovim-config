return {
	"norcalli/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("colorizer").setup({
			filetypes = {
				"*",
				"!vim",
				css = { rgb_fn = true },
				html = { names = false },
				javascript = { RRGGBBAA = true },
				typescript = { RRGGBBAA = true },
				"!lazy",
			},
			user_default_options = {
				RGB = true,
				RRGGBB = true,
				names = true,
				RRGGBBAA = false,
				AARRGGBB = false,
				rgb_fn = false,
				hsl_fn = false,
				css = false,
				css_fn = false,
				mode = "background",
				tailwind = false,
				sass = { enable = false, parsers = { "css" } },
				virtualtext = "■",
				always_update = false,
			},
			buftypes = {},
		})
		vim.keymap.set("n", "<leader>tc", "<cmd>ColorizerToggle<CR>", { desc = "Toggle colorizer" })
	end,
}

-- #FFFFFF
-- #000000
