local jdtls = require("jdtls")

-- Determine OS and paths
local home = os.getenv("HOME")
if not home then
	home = os.getenv("USERPROFILE") -- Windows fallback
end
local mason_path = vim.fn.stdpath("data") .. "/mason"

-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
	return
end

-- Eclipse workspace directory
local eclipse_workspace = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- Debug bundles
local bundles = {}

-- Java debug
local java_debug_path = mason_path .. "/packages/java-debug-adapter/extension/server/"
local java_debug_jar = vim.fn.glob(java_debug_path .. "com.microsoft.java.debug.plugin-*.jar", 1)
if java_debug_jar ~= "" then
	table.insert(bundles, java_debug_jar)
end

-- Java test bundles
local java_test_path = mason_path .. "/packages/java-test/extension/server/"
local java_test_jars = vim.split(vim.fn.glob(java_test_path .. "*.jar", 1), "\n")
for _, jar in ipairs(java_test_jars) do
	if jar ~= "" and jar:match("%.jar$") then
		table.insert(bundles, jar)
	end
end

-- LSP on_attach callback
local function on_attach(client, bufnr)
	-- Your existing keymaps from lspconfig will work through the LspAttach autocmd

	-- Setup DAP for debugging
	require("jdtls").setup_dap({ hotcodereplace = "auto" })
	require("jdtls.dap").setup_dap_main_class_configs()

	-- Java-specific keymaps
	local opts = { noremap = true, silent = true, buffer = bufnr }
	local keymap = vim.keymap.set

	keymap("n", "<leader>jo", function()
		require("jdtls").organize_imports()
	end, { desc = "Organize Imports", buffer = bufnr })
	keymap("n", "<leader>jv", function()
		require("jdtls").extract_variable()
	end, { desc = "Extract Variable", buffer = bufnr })
	keymap("n", "<leader>jc", function()
		require("jdtls").extract_constant()
	end, { desc = "Extract Constant", buffer = bufnr })
	keymap(
		"v",
		"<leader>jm",
		[[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
		{ desc = "Extract Method", buffer = bufnr }
	)

	-- Enable document highlighting
	if client.server_capabilities.documentHighlightProvider then
		local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			callback = vim.lsp.buf.document_highlight,
			buffer = bufnr,
			group = group,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			callback = vim.lsp.buf.clear_references,
			buffer = bufnr,
			group = group,
		})
	end
end

-- Detect OS for config path
local function get_config_dir()
	if vim.fn.has("mac") == 1 then
		return mason_path .. "/packages/jdtls/config_mac"
	elseif vim.fn.has("unix") == 1 then
		return mason_path .. "/packages/jdtls/config_linux"
	else
		return mason_path .. "/packages/jdtls/config_win"
	end
end

-- JDTLS configuration
local config = {
	-- The command that starts the language server
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		vim.fn.glob(mason_path .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration",
		get_config_dir(),
		"-data",
		eclipse_workspace,
	},

	-- Language server root directory
	root_dir = root_dir,

	-- Language server settings
	settings = {
		java = {
			eclipse = { downloadSources = true },
			configuration = { updateBuildConfiguration = "interactive" },
			maven = { downloadSources = true },
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true },
			references = { includeDecompiledSources = true },
			format = { enabled = true },
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				useBlocks = true,
			},
		},
	},

	-- Server flags
	flags = {
		allow_incremental_sync = true,
	},

	-- Initialization options
	init_options = {
		bundles = bundles,
	},

	-- LSP capabilities with completion support
	capabilities = require("cmp_nvim_lsp").default_capabilities(),

	-- On attach callback
	on_attach = on_attach,
}

-- Start or attach to language server
require("jdtls").start_or_attach(config)

-- Commands
vim.api.nvim_create_user_command("JavaUpdateConfig", function()
	require("jdtls").update_projects_config()
end, { desc = "Update Java project configuration" })
