-- icons
local icons = require("config.icons")

-- blink cmp
---@module 'blink.cmp'
---@type blink.cmp.Config
--TODO what else
require("blink.cmp").setup({

	keymap = { preset = "enter" },

	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
		kind_icons = icons.lspkind,
	},

	-- (Default) Only show the documentation popup when manually triggered
	completion = {
		documentation = {
			auto_show = true,
		},
		menu = {
			draw = {
				columns = {
					{ "kind_icon", "label", gap = 2 },
					{ "kind", "label_description", gap = 2 },
				},
			},
		},
		list = {
			selection = {
				auto_insert = true,
			},
		},
	},

	-- Default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, due to `opts_extend`
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},

	fuzzy = {
		implementation = "lua",
	},

	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
})
