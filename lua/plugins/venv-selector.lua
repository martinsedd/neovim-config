return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
		"mfussenegger/nvim-dap-python",
		"nvim-lua/plenary.nvim",
	},
	lazy = false,
	branch = "regexp",
	config = function()
		require("venv-selector").setup({
			settings = {
				options = {
					notify_user_on_venv_activation = true,
					set_environment_variables = true,
					on_venv_activate_callback = nil,
					enable_default_searches = true,
					enable_cached_venvs = true,
					cached_venv_automatic_activation = false,
					activate_venv_in_terminal = true,
					set_environment_variables = true,
					notify_user_on_venv_activation = true,
				},
				search = {
					-- Standard venv locations
					my_venvs = {
						command = "find ~/venvs -maxdepth 2 -name 'pyvenv.cfg' 2>/dev/null",
						type = "venv",
					},
					workspace_venvs = {
						command = "find $PWD -maxdepth 3 -name 'pyvenv.cfg' 2>/dev/null",
						type = "venv",
					},
					project_venv = {
						command = "find $PWD/venv $PWD/.venv $PWD/env -name 'pyvenv.cfg' 2>/dev/null",
						type = "venv",
					},
					-- Poetry environments
					poetry = {
						command = "find ~/.cache/pypoetry/virtualenvs -maxdepth 2 -name 'pyvenv.cfg' 2>/dev/null",
						type = "poetry",
					},
					-- Pipenv environments
					pipenv = {
						command = "find ~/.local/share/virtualenvs -maxdepth 2 -name 'pyvenv.cfg' 2>/dev/null",
						type = "pipenv",
					},
					-- Conda environments
					conda_base = {
						command = "find ~/anaconda3/envs ~/miniconda3/envs -maxdepth 2 -name 'pyvenv.cfg' 2>/dev/null",
						type = "conda",
					},
					-- System-wide conda
					system_conda = {
						command = "find /opt/conda/envs /opt/miniconda3/envs -maxdepth 2 -name 'pyvenv.cfg' 2>/dev/null",
						type = "conda",
					},
					-- Pyenv environments
					pyenv = {
						command = "find ~/.pyenv/versions -maxdepth 2 -name 'pyvenv.cfg' 2>/dev/null",
						type = "pyenv",
					},
					-- Custom locations (add your own paths here)
					custom_venvs = {
						command = "find ~/python-envs ~/dev/venvs -maxdepth 2 -name 'pyvenv.cfg' 2>/dev/null",
						type = "venv",
					},
				},
			},
		})

		-- Enhanced keymaps with descriptions
		local keymap = vim.keymap.set
		local opts = { noremap = true, silent = true }

		-- Core venv selection
		keymap(
			"n",
			"<leader>vs",
			"<cmd>VenvSelect<CR>",
			vim.tbl_extend("force", opts, { desc = "Select Python virtual environment" })
		)

		keymap(
			"n",
			"<leader>vc",
			"<cmd>VenvSelectCached<CR>",
			vim.tbl_extend("force", opts, { desc = "Select from cached virtual environments" })
		)

		-- Additional useful commands
		keymap("n", "<leader>vd", function()
			local venv = require("venv-selector").get_active_venv()
			if venv then
				print("Current venv: " .. venv)
			else
				print("No virtual environment activated")
			end
		end, vim.tbl_extend("force", opts, { desc = "Display current virtual environment" }))

		keymap("n", "<leader>vr", function()
			vim.cmd("LspRestart")
			print("LSP restarted with current virtual environment")
		end, vim.tbl_extend("force", opts, { desc = "Restart LSP with current venv" }))

		-- Quick venv creation (requires user input)
		keymap("n", "<leader>vn", function()
			local venv_name = vim.fn.input("Virtual environment name: ")
			if venv_name ~= "" then
				local cmd = string.format("python3 -m venv ~/venvs/%s", venv_name)
				vim.fn.system(cmd)
				print(string.format("Created virtual environment: ~/venvs/%s", venv_name))
				vim.cmd("VenvSelect")
			end
		end, vim.tbl_extend("force", opts, { desc = "Create new virtual environment" }))

		-- Auto-activate venv on Python file open
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*.py",
			callback = function()
				local venv_selector = require("venv-selector")

				-- Check if we're in a project with a local venv
				local local_venvs = {
					vim.fn.getcwd() .. "/venv",
					vim.fn.getcwd() .. "/.venv",
					vim.fn.getcwd() .. "/env",
				}

				for _, venv_path in ipairs(local_venvs) do
					if vim.fn.isdirectory(venv_path) == 1 then
						local pyvenv_cfg = venv_path .. "/pyvenv.cfg"
						if vim.fn.filereadable(pyvenv_cfg) == 1 then
							venv_selector.activate_venv(venv_path)
							return
						end
					end
				end

				-- If no local venv, try to use cached
				if not venv_selector.get_active_venv() then
					local cached = venv_selector.get_cached_venv()
					if cached then
						venv_selector.activate_venv(cached)
					end
				end
			end,
		})

		-- Integration with toggleterm for venv-aware terminals
		vim.api.nvim_create_autocmd("User", {
			pattern = "VenvActivated",
			callback = function()
				-- Update DAP Python if available
				local ok, dap_python = pcall(require, "dap-python")
				if ok then
					local venv = require("venv-selector").get_active_venv()
					if venv then
						dap_python.setup(venv .. "/bin/python")
					end
				end

				-- Restart LSP servers
				vim.schedule(function()
					vim.cmd("LspRestart pyright")
				end)
			end,
		})

		-- Status line integration (if using lualine)
		if pcall(require, "lualine") then
			require("lualine").setup({
				sections = {
					lualine_x = {
						{
							function()
								local venv = require("venv-selector").get_active_venv()
								if venv then
									return "🐍 " .. vim.fn.fnamemodify(venv, ":t")
								end
								return ""
							end,
							color = { fg = "#98be65" },
						},
						"encoding",
						"fileformat",
						"filetype",
					},
				},
			})
		end

		-- Which-key integration
		if pcall(require, "which-key") then
			require("which-key").add({
				{ "<leader>v", group = "virtual env" },
				{ "<leader>vs", desc = "Select virtual environment" },
				{ "<leader>vc", desc = "Select cached virtual environment" },
				{ "<leader>vd", desc = "Display current virtual environment" },
				{ "<leader>vr", desc = "Restart LSP with current venv" },
				{ "<leader>vn", desc = "Create new virtual environment" },
			})
		end

		-- Python project detection and auto-setup
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
			pattern = { "*.py", "pyproject.toml", "requirements.txt", "Pipfile", "setup.py" },
			callback = function()
				-- Check for poetry project
				if vim.fn.filereadable("pyproject.toml") == 1 then
					local content = vim.fn.readfile("pyproject.toml")
					for _, line in ipairs(content) do
						if line:match("%[tool%.poetry%]") then
							vim.notify(
								"Poetry project detected. Use :VenvSelect to choose poetry environment.",
								vim.log.levels.INFO
							)
							break
						end
					end
				end

				-- Check for pipenv project
				if vim.fn.filereadable("Pipfile") == 1 then
					vim.notify(
						"Pipenv project detected. Use :VenvSelect to choose pipenv environment.",
						vim.log.levels.INFO
					)
				end

				-- Check for requirements.txt
				if vim.fn.filereadable("requirements.txt") == 1 and vim.fn.isdirectory("venv") == 0 then
					vim.notify(
						"Requirements.txt found but no venv detected. Consider creating one with <leader>vn",
						vim.log.levels.WARN
					)
				end
			end,
		})
	end,
}
