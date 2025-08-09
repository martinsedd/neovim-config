return {
	"ray-x/lsp_signature.nvim",
	event = "VeryLazy",
	config = function()
		require("lsp_signature").setup({
			bind = true,
			handler_opts = {
				border = "rounded",
			},
			floating_window = true,
			floating_window_above_cur_line = true,
			floating_window_off_x = 1,
			floating_window_off_y = 0,
			close_timeout = 4000,
			fix_pos = false,
			hint_enable = true,
			hint_prefix = "🐼 ",
			hint_scheme = "String",
			hint_inline = function()
				return false
			end,
			hi_parameter = "LspSignatureActiveParameter",
			max_height = 12,
			max_width = 80,
			noice = false,
			always_trigger = false,
			auto_close_after = nil,
			extra_trigger_after = {},
			zindex = 200,
			padding = "",
			transparency = nil,
			shadow_blend = 36,
			shadow_guibg = "Black",
			timer_interval = 200,
			toggle_key = nil,
			toggle_key_flip_floatwin_setting = false,

			select_signature_key = nil,
			move_cursor_key = nil,
		})
	end,
}
