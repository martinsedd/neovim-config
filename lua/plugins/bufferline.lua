return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	event = "VeryLazy",
	config = function()
		local bufferline = require("bufferline")

		bufferline.setup({
			options = {
				mode = "buffers", -- set to "tabs" to only show tabpages instead
				style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
				themable = true,
				numbers = "none",
				close_command = "bdelete! %d", -- can be a string | function, | false see "Mouse actions"
				right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
				left_mouse_command = "buffer %d", -- can be a string | function, | false see "Mouse actions"
				middle_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
				indicator = {
					icon = "▎", -- this should be omitted if indicator style is not 'icon'
					style = "icon",
				},
				buffer_close_icon = "󰅖",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 30,
				max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
				truncate_names = true, -- whether or not tab names should be truncated
				tab_size = 21,
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
				-- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					return "(" .. count .. ")"
				end,
				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = true,
				show_tab_indicators = true,
				show_duplicate_prefix = true,
				persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
				move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
				separator_style = "slant",
				enforce_regular_tabs = true,
				always_show_bufferline = true,
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
				sort_by = "insert_after_current",
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						text_align = "left",
						separator = true,
					},
				},
			},
		})

		-- Keymaps
		local keymap = vim.keymap.set

		keymap("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Go to next buffer" })
		keymap("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Go to previous buffer" })
		keymap("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
		keymap("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>", { desc = "Close buffers to the right" })
		keymap("n", "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close buffers to the left" })
		keymap("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>", { desc = "Toggle pin buffer" })
		keymap("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Close unpinned buffers" })

		-- Buffer navigation by number
		for i = 1, 9 do
			keymap("n", "<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<CR>", { desc = "Go to buffer " .. i })
		end
	end,
}
