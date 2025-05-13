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
	local mode = vim.fn.mode()
	local text = ""

	if mode:match("[vV]") then -- Visual/Visual Line/Visual Block mode
		-- Save and restore register x to avoid clobbering
		local saved_reg = vim.fn.getreg("x")
		local saved_reg_type = vim.fn.getregtype("x")

		-- Yank selected text silently to register x
		vim.cmd('silent normal! "xy')
		text = vim.fn.getreg("x")

		-- Restore original register x content
		vim.fn.setreg("x", saved_reg, saved_reg_type)
	else -- Normal mode
		text = vim.api.nvim_get_current_line()
	end

	local ft = vim.bo.filetype
	if ft == "" then
		ft = "unknown"
	end

	print("Selected text: " .. text .. " - " .. ft)
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
