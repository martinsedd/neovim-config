return {
	"akinsho/toggleterm.nvim",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<c-\>]],
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			terminal_mappings = true,
			persist_size = true,
			persist_mode = true,
			direction = "float",
			close_on_exit = true,
			shell = vim.o.shell,
			auto_scroll = true,
			float_opts = {
				border = "curved",
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
			winbar = {
				enabled = false,
				name_formatter = function(term)
					return term.name
				end,
			},
		})

		local keymap = vim.keymap.set
		local opts = { noremap = true, silent = true }

		keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
		keymap("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
		keymap(
			"n",
			"<leader>tv",
			"<cmd>ToggleTerm direction=vertical size=80<CR>",
			{ desc = "Toggle vertical terminal" }
		)

		function _G.set_terminal_keymaps()
			local term_opts = { buffer = 0 }
			keymap("t", "<esc>", [[<C-\><C-n>]], term_opts)
			keymap("t", "jk", [[<C-\><C-n>]], term_opts)
			keymap("t", "<C-h>", [[<Cmd>wincmd h<CR>]], term_opts)
			keymap("t", "<C-j>", [[<Cmd>wincmd j<CR>]], term_opts)
			keymap("t", "<C-k>", [[<Cmd>wincmd k<CR>]], term_opts)
			keymap("t", "<C-l>", [[<Cmd>wincmd l<CR>]], term_opts)
			keymap("t", "<C-w>", [[<C-\><C-n><C-w>]], term_opts)
		end

		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

		local Terminal = require("toggleterm.terminal").Terminal

		local lazygit = Terminal:new({
			cmd = "lazygit",
			dir = "git_dir",
			direction = "float",
			float_opts = {
				border = "double",
			},
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
			on_close = function(term)
				vim.cmd("startinsert!")
			end,
		})

		function _LAZYGIT_TOGGLE()
			lazygit:toggle()
		end

		local node = Terminal:new({ cmd = "node", hidden = true })

		function _NODE_TOGGLE()
			node:toggle()
		end

		local python = Terminal:new({ cmd = "python3", hidden = true })

		function _PYTHON_TOGGLE()
			python.toggle()
		end

		keymap("n", "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "Toggle Lazygit" })
		keymap("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>", { desc = "Toggle Node REPL" })
		keymap("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Toggle Python REPL" })
	end,
}
