local M = {}

-- Default configuration with keymaps
M.config = {
	message = "Hello from nv-snippets",
	keymaps = {
		greet = nil, -- Disabled by default; user must opt-in
	},
}

-- Function to trigger
function M.greet()
	print(M.config.message)
end

-- Setup handler
function M.setup(opts)
	-- Merge user options with defaults
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	-- Set keymaps only if defined by user
	if M.config.keymaps.greet then
		vim.keymap.set(
			{ "n", "v" }, -- Normal + Visual modes
			M.config.keymaps.greet,
			M.greet,
			{ noremap = true, silent = true }
		)
	end
end

-- Optional: Still provide a command for non-keymap users
vim.api.nvim_create_user_command("NvSnippetsGreet", M.greet, {})

return M
