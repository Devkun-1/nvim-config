-- oil
require("oil").setup({
	-- oil will take over directory buffers (e.g. `vim .` or `:e src/`)
	-- set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
	default_file_explorer = true,
	-- id is automatically added at the beginning, and name at the end
	-- see :help oil-columns
	columns = {
		"icon",
		-- "permissions",
		-- "size",
		-- "mtime",
	},
	-- buffer-local options to use for oil buffers
	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},
	-- window-local options to use for oil buffers
	win_options = {
		wrap = false,
		signcolumn = "no",
		cursorcolumn = false,
		foldcolumn = "0",
		spell = false,
		list = false,
		conceallevel = 3,
		concealcursor = "nvic",
	},
	-- send deleted files to the trash instead of permanently deleting them (:help oil-trash)
	delete_to_trash = false,
	-- skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
	skip_confirm_for_simple_edits = false,
	-- selecting a new/moved/renamed file or directory will prompt you to save changes first
	-- (:help prompt_save_on_select_new_entry)
	prompt_save_on_select_new_entry = true,
	-- oil will automatically delete hidden buffers after this delay
	-- you can set the delay to false to disable cleanup entirely
	-- note that the cleanup process only starts when none of the oil buffers are currently displayed
	cleanup_delay_ms = 2000,
	lsp_file_methods = {
		-- enable or disable lsp file operations
		enabled = true,
		-- time to wait for lsp file operations to complete before skipping
		timeout_ms = 1000,
		-- set to true to autosave buffers that are updated with lsp willrenamefiles
		-- set to "unmodified" to only save unmodified buffers
		autosave_changes = false,
	},
	-- constrain the cursor to the editable parts of the oil buffer
	-- set to `false` to disable, or "name" to keep it on the file names
	constrain_cursor = "editable",
	-- set to true to watch the filesystem for changes and reload oil
	watch_for_changes = false,
	-- keymaps in oil buffer. can be any value that `vim.keymap.set` accepts or a table of keymap
	-- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
	-- additionally, if it is a string that matches "actions.<name>",
	-- it will use the mapping at require("oil.actions").<name>
	-- set to `false` to remove a keymap
	-- see :help oil-actions for a list of all available actions
	keymaps = {
		["g?"] = { "actions.show_help", mode = "n" },
		["<cr>"] = "actions.select",
		["<c-s>"] = { "actions.select", opts = { vertical = true } },
		["<c-h>"] = { "actions.select", opts = { horizontal = true } },
		["<c-t>"] = { "actions.select", opts = { tab = true } },
		["<c-p>"] = "actions.preview",
		["<c-c>"] = { "actions.close", mode = "n" },
		["<c-l>"] = "actions.refresh",
		["-"] = { "actions.parent", mode = "n" },
		["_"] = { "actions.open_cwd", mode = "n" },
		["`"] = { "actions.cd", mode = "n" },
		["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["gx"] = "actions.open_external",
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["g\\"] = { "actions.toggle_trash", mode = "n" },
	},
	-- set to false to disable all of the above keymaps
	use_default_keymaps = true,
	view_options = {
		-- show files and directories that start with "."
		show_hidden = false,
		-- this function defines what is considered a "hidden" file
		is_hidden_file = function(name, bufnr)
			local m = name:match("^%.")
			return m ~= nil
		end,
		-- this function defines what will never be shown, even when `show_hidden` is set
		is_always_hidden = function(name, bufnr)
			return false
		end,
		-- sort file names with numbers in a more intuitive order for humans.
		-- can be "fast", true, or false. "fast" will turn it off for large directories.
		natural_order = "fast",
		-- sort file and directory names case insensitive
		case_insensitive = false,
		sort = {
			-- sort order can be "asc" or "desc"
			-- see :help oil-columns to see which columns are sortable
			{ "type", "asc" },
			{ "name", "asc" },
		},
		-- customize the highlight group for the file name
		highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
			return nil
		end,
	},
	-- extra arguments to pass to scp when moving/copying files over ssh
	extra_scp_args = {},
	-- extra arguments to pass to aws s3 when creating/deleting/moving/copying files using aws s3
	extra_s3_args = {},
	-- experimental support for performing file operations with git
	git = {
		-- return true to automatically git add/mv/rm files
		add = function(path)
			return false
		end,
		mv = function(src_path, dest_path)
			return false
		end,
		rm = function(path)
			return false
		end,
	},
	-- configuration for the floating window in oil.open_float
	float = {
		-- padding around the floating window
		padding = 2,
		-- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		max_width = 0,
		max_height = 0,
		border = nil,
		win_options = {
			winblend = 0,
		},
		-- optionally override the oil buffers window title with custom function: fun(winid: integer): string
		get_win_title = nil,
		-- preview_split: split direction: "auto", "left", "right", "above", "below".
		preview_split = "auto",
		-- this is the config that will be passed to nvim_open_win.
		-- change values here to customize the layout
		override = function(conf)
			return conf
		end,
	},
	-- configuration for the file preview window
	preview_win = {
		-- whether the preview window is automatically updated when the cursor is moved
		update_on_cursor_moved = true,
		-- how to open the preview window "load"|"scratch"|"fast_scratch"
		preview_method = "fast_scratch",
		-- a function that returns true to disable preview on a file e.g. to avoid lag
		disable_preview = function(filename)
			return false
		end,
		-- window-local options to use for preview window buffers
		win_options = {},
	},
	-- configuration for the floating action confirmation window
	confirmation = {
		-- width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		-- min_width and max_width can be a single value or a list of mixed integer/float types.
		-- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
		max_width = 0.9,
		-- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
		min_width = { 40, 0.4 },
		-- optionally define an integer/float for the exact width of the preview window
		width = nil,
		-- height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		-- min_height and max_height can be a single value or a list of mixed integer/float types.
		-- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
		max_height = 0.9,
		-- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
		min_height = { 5, 0.1 },
		-- optionally define an integer/float for the exact height of the preview window
		height = nil,
		border = nil,
		win_options = {
			winblend = 0,
		},
	},
	-- configuration for the floating progress window
	progress = {
		max_width = 0.9,
		min_width = { 40, 0.4 },
		width = nil,
		max_height = { 10, 0.9 },
		min_height = { 5, 0.1 },
		height = nil,
		border = nil,
		minimized_border = "none",
		win_options = {
			winblend = 0,
		},
	},
	-- configuration for the floating ssh window
	ssh = {
		border = nil,
	},
	-- configuration for the floating keymaps help window
	keymaps_help = {
		border = nil,
	},
})

-- telescope
local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		-- use ripgrep as the search engine (fast, must be installed on system)
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden", -- include hidden files
			"--glob=!.git/*", -- but exclude .git directory
		},
		prompt_prefix = "🔍 ",
		selection_caret = "➤ ",
		path_display = { "truncate" },
		sorting_strategy = "ascending",
		layout_config = {
			horizontal = { prompt_position = "top", preview_width = 0.55 },
		},
		file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
		mappings = {
			-- i = {
			-- 	["<c-j>"] = actions.move_selection_next,
			-- 	["<c-k>"] = actions.move_selection_previous,
			-- 	["<esc>"] = actions.close, -- close with single esc in insert mode
			-- },

			-- mappings while in normal mode (press <esc> once to enter normal mode first)
			n = {
				["j"] = actions.move_selection_next, -- move down
				["k"] = actions.move_selection_previous, -- move up
				["q"] = actions.close, -- quick close
				["<c-c>"] = actions.close,
			},
		},
	},
	pickers = {
		find_files = {
			hidden = true, -- show hidden files too
		},
		diagnostics = {
			-- theme = "dropdown", -- compact bottom-panel style, good for error lists
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true, -- use fzf sorter for generic picker
			override_file_sorter = true, -- use fzf sorter for file picker
			case_mode = "smart_case",
		},
	},
})

-- load fzf-native extension after setup
telescope.load_extension("fzf")

-- auto pairs
require("nvim-autopairs").setup({})

-- snacks
require("snacks").setup({
	-- bigfile = { enabled = true },
	-- dashboard = { enabled = true },
	-- explorer = { enabled = true },
	indent = { enabled = true },
	-- input = { enabled = true },
	-- picker = { enabled = true },
	notifier = { enabled = true },
	-- quickfile = { enabled = true },
	-- scope = { enabled = true },
	-- scroll = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
})

-- lazydev
require("lazydev").setup({})

-- conform
require("conform").setup({
	format_on_save = function(bufnr)
		-- Get the full path of the current buffer
		local bufname = vim.api.nvim_buf_get_name(bufnr)

		-- Disable auto-format specifically for dwl / suckless config files
		if bufname:match("config%.def%.h$") or bufname:match("config%.h$") then
			return
		end

		-- Return format options for all other files
		return { timeout_ms = 500, lsp_fallback = true }
	end,

	-- Your existing formatters configuration
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettier" },
		c = { "clang-format" },
	},
	-- Trigger auto-format whenever you save the file
})

-- nvim-ts-autotag
require("nvim-ts-autotag").setup({
	opts = {
		enable_close = true, -- auto close tags
		enable_rename = true, -- auto rename the matching closing tag
		enable_close_on_slash = false,
	},
})

-- bufferline
require("bufferline").setup({
	options = {
		mode = "buffers", -- "buffers" | "tabs"
		separator_style = "thick", -- "slant" | "slope" | "thick" | "thin"
		always_show_bufferline = false,
		show_buffer_close_icons = true,
		show_close_icon = true,
		color_icons = true,

		-- Integrates with LSP diagnostics to show indicators
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,

		-- Hides NvimTree or Neo-tree from the tabline area
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				text_align = "left",
				separator = true,
			},
			{
				filetype = "neo-tree",
				text = "File Explorer",
				text_align = "left",
				separator = true,
			},
		},
	},
	highlights = {
		fill = {
			bg = "NONE",
		},
		background = {
			bg = "NONE",
		},
		buffer_selected = {
			bg = "NONE",
			bold = true,
		},
		separator = {
			bg = "NONE",
		},
		separator_visible = {
			bg = "NONE",
		},
		separator_selected = {
			bg = "NONE",
		},
		offset_separator = {
			bg = "NONE",
		},
	},
})
