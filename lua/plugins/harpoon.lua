return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end

		local keymap = vim.keymap.set

		keymap("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "Add file to harpoon" })

		keymap("n", "<leader>hh", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Toggle harpoon menu" })
		keymap("n", "<leader>ht", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Open harpoon window with telescope" })

		-- Quick navigation to first 4 files
		keymap("n", "<leader>h1", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon file 1" })
		keymap("n", "<leader>h2", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon file 2" })
		keymap("n", "<leader>h3", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon file 3" })
		keymap("n", "<leader>h4", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon file 4" })

		-- Toggle previous & next buffers stored within Harpoon list
		keymap("n", "<leader>hp", function()
			harpoon:list():prev()
		end, { desc = "Previous harpoon file" })
		keymap("n", "<leader>hn", function()
			harpoon:list():next()
		end, { desc = "Next harpoon file" })

		-- Clear all harpoon marks
		keymap("n", "<leader>hc", function()
			harpoon:list():clear()
		end, { desc = "Clear harpoon list" })
	end,
}
