return {
	"echasnovski/mini.surround",
	version = "*",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("mini.surround").setup({
			custom_surroundings = nil,
			highlight_duration = 500,
			mappings = {
				add = "sa",
				delete = "sd",
				find = "sf",
				find_left = "sr",
				update_n_lines = "sn",
				suffix_last = "l",
				suffix_next = "n",
			},
			n_lines = 20,
			respect_selection_type = false,
			search_method = "cover",
			silent = false,
		})
	end,
}
