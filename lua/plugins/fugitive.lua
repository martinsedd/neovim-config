return {
	"tpope/vim-fugitive",
	event = "VeryLazy",
	config = function()
		local keymap = vim.keymap.set

		keymap("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
		keymap("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git diff" })
		keymap("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
		keymap("n", "<leader>gl", "<cmd>Git log<CR>", { desc = "Git log" })
		keymap("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
		keymap("n", "<leader>gP", "<cmd>Git pull<CR>", { desc = "Git pull" })
		keymap("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
	end,
}
