-- create functions for concise definitions of key mappings
local map = {}
for _, noremap in pairs({ false, true }) do
	for _, silent in pairs({ false, true }) do
		for _, expr in pairs({ false, true }) do
			local name = ""
			if noremap then
				name = name .. "nore"
			end
			name = name .. "map"
			if silent then
				name = name .. "_silent"
			end
			if expr then
				name = name .. "_expr"
			end

			map[name] = function(mode, shortcut, command, opts)
				if not opts then
					opts = {}
				end
				opts.noremap = noremap
				opts.silent = silent
				opts.expr = expr
				-- https://nanotipsforvim.prose.sh/prevent-duplicate-keybindings
				if opts.unique == nil then
					opts.unique = true
				end

				vim.keymap.set(mode, shortcut, command, opts)
			end

			for _, mode in pairs({ "n", "i", "c", "v" }) do
				map[mode .. name] = function(shortcut, command, opts)
					map[name]({ mode }, shortcut, command, opts)
				end
			end
		end
	end
end

map.cnoremap_colon = function(lhs, rhs, opts)
	map.cnoremap(lhs, "<c-r>=(getcmdtype()==':' ? ('" .. rhs .. "') : ('" .. lhs .. "'))<CR>", opts)
end

map.cnoremap_colon_prefix = function(lhs, rhs, opts)
	map.cnoremap(lhs, "<c-r>=(getcmdtype()==':' && getcmdpos()==1 ? ('" .. rhs .. "') : ('" .. lhs .. "'))<CR>", opts)
end

local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

local function values(t)
	local res = {}

	for _, v in pairs(t) do
		table.insert(res, v)
	end

	return res
end

require("lazy").setup(
	values({
		textobj_quotes = {
			"beloglazov/vim-textobj-quotes",
			dependencies = { "kana/vim-textobj-user" },
		},
		textobj_indent = {
			"kana/vim-textobj-indent",
			dependencies = { "kana/vim-textobj-user" },
		},
		textobj_param = {
			"sgur/vim-textobj-parameter",
			dependencies = { "kana/vim-textobj-user" },
		},
		textobj_python = {
			"bps/vim-textobj-python",
			dependencies = { "kana/vim-textobj-user" },
		},
		textobj_var_segment = {
			"Julian/vim-textobj-variable-segment",
			dependencies = { "kana/vim-textobj-user" },
		},
		textobj_xmlattr = {
			"whatyouhide/vim-textobj-xmlattr",
			dependencies = { "kana/vim-textobj-user" },
		},
		textobj_chainmember = {
			"D4KU/vim-textobj-chainmember",
			dependencies = { "kana/vim-textobj-user" },
		},
		textobj_chunk = {
			"Chun-Yang/vim-textobj-chunk",
			dependencies = { "kana/vim-textobj-user" },
			init = function()
				vim.g.loaded_textobj_chunk = 1 -- no default mappings
			end,
			config = function()
				vim.fn["textobj#user#plugin"]("chunk", {
					["-"] = {
						["select-a"] = "ab",
						["*select-a-function*"] = "textobj#chunk#select_a",
						["select-i"] = "ib",
						["*select-i-function*"] = "textobj#chunk#select_i",
					},
				})
			end,
		},
		textobj_brace = {
			"Julian/vim-textobj-brace",
			dependencies = { "kana/vim-textobj-user" },
			init = function()
				vim.g.loaded_textobj_brace = 1 -- no default mappings
			end,
			config = function()
				vim.fn["textobj#user#plugin"]("brace", {
					["-"] = {
						["select-a"] = "ao",
						["*select-a-function*"] = "textobj#brace#select_a",
						["select-i"] = "io",
						["*select-i-function*"] = "textobj#brace#select_i",
					},
				})
			end,
		},
		commentary = {
			"tpope/vim-commentary",
		},
		["repeat"] = {
			"tpope/vim-repeat",
		},
		fugitive = {
			"tpope/vim-fugitive",
		},
		surround = {
			"tpope/vim-surround",
			init = function()
				vim.g.surround_no_insert_mappings = 1
			end,
		},
		yoink = {
			"svermeulen/vim-yoink",
			config = function()
				map.nmap("<c-p>", "<plug>(YoinkPostPasteSwapBack)")
				map.nmap("<c-n>", "<plug>(YoinkPostPasteSwapForward)")

				map.nmap("p", "<plug>(YoinkPaste_p)")
				map.nmap("P", "<plug>(YoinkPaste_P)")

				-- paste with small p shouldn't swap in visual mode, large P swaps
				map.vnoremap("p", "P")
				map.vnoremap("P", "p")

				vim.g.yoinkMaxItems = 100
				vim.g.yoinkMoveCursorToEndOfPaste = 1
				vim.g.yoinkIncludeNamedRegisters = "0"
				vim.g.yoinkSavePersistently = 1
			end,
		},
		tmux_navigator = {
			"christoomey/vim-tmux-navigator",
			init = function()
				vim.g.tmux_navigator_no_mappings = 1
			end,
			config = function()
				map.nnoremap("<C-Left>", ":TmuxNavigateLeft<cr>")
				map.inoremap("<C-Left>", "<C-O>:TmuxNavigateLeft<cr>")
				map.nnoremap("<C-Down>", ":TmuxNavigateDown<cr>")
				map.inoremap("<C-Down>", "<C-O>:TmuxNavigateDown<cr>")
				map.nnoremap("<C-Up>", ":TmuxNavigateUp<cr>")
				map.inoremap("<C-Up>", "<C-O>:TmuxNavigateUp<cr>")
				map.nnoremap("<C-Right>", ":TmuxNavigateRight<cr>")
				map.inoremap("<C-Right>", "<C-O>:TmuxNavigateRight<cr>")
			end,
		},
		luasnip = {
			"L3MON4D3/LuaSnip",
			dependencies = { "rafamadriz/friendly-snippets" },
			build = "make install_jsregexp",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
				local ls = require("luasnip")

				map.map_silent({ "i" }, "<C-K>", function()
					ls.expand()
				end)
				map.map_silent({ "i", "s" }, "<C-L>", function()
					ls.jump(1)
				end)
				map.map_silent({ "i", "s" }, "<C-J>", function()
					ls.jump(-1)
				end)

				map.map_silent({ "i", "s" }, "<C-E>", function()
					if ls.choice_active() then
						ls.change_choice(1)
					end
				end)
				map.map_silent({ "i", "s" }, "<C-D>", function()
					if ls.choice_active() then
						ls.change_choice(-1)
					end
				end)

				ls.filetype_extend("htmldjango", { "html" })
				ls.filetype_extend("python", { "django" })
			end,
		},
		nvim_cmp = {
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"dmitmel/cmp-cmdline-history",
				"hrsh7th/cmp-nvim-lsp-signature-help",
				"hrsh7th/cmp-nvim-lua",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
				"onsails/lspkind.nvim",
			},
			config = function()
				local cmp = require("cmp")

				cmp.setup({
					snippet = {
						expand = function(args)
							require("luasnip").lsp_expand(args.body)
							-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
						end,
					},
					window = {
						completion = cmp.config.window.bordered(),
						documentation = cmp.config.window.bordered(),
					},
					mapping = cmp.mapping.preset.insert({
						["<CR>"] = cmp.mapping.confirm(),
						["<Esc>"] = cmp.mapping.abort(),
						["<C-[>"] = cmp.mapping.abort(),
						["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
						["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "nvim_lsp_signature_help" },
						{ name = "luasnip" },
					}, {
						{
							name = "buffer",
							option = {
								get_bufnrs = function()
									return vim.api.nvim_list_bufs()
								end,
							},
						},
						{ name = "nvim_lua" },
					}),
					formatting = {
						format = require("lspkind").cmp_format({
							mode = "symbol",
							maxwidth = function()
								return math.floor(0.45 * vim.o.columns)
							end,
							ellipsis_char = "...",
						}),
					},
				})
				cmp.setup.cmdline({ "/", "?" }, {
					mapping = cmp.mapping.preset.cmdline(),
					sources = {
						{ name = "buffer" },
					},
				})
				cmp.setup.cmdline(":", {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({
						{ name = "path" },
					}, {
						{ name = "cmdline" },
						{ name = "cmdline_history" },
					}),
				})
			end,
		},
		mason = {
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
			end,
		},
		mason_lspconfig = {
			"williamboman/mason-lspconfig.nvim",
			dependencies = { "williamboman/mason.nvim" },
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = { "pyright" },
				})
			end,
		},
		lspconfig = {
			"neovim/nvim-lspconfig",
			dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
			config = function()
				require("lspconfig").pyright.setup({
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "off",
								disableOrganizeImports = true,
								-- these 3 are default for pyright in lspconfig
								-- autoSearchPaths = true,
								-- useLibraryCodeForTypes = true,
								-- diagnosticMode = 'openFilesOnly',
							},
						},
					},
				})

				map.nmap("<Leader>l", vim.diagnostic.setloclist)
				map.nmap("<Leader>d", vim.lsp.buf.definition)
			end,
		},
		lint = {
			"mfussenegger/nvim-lint",
			config = function()
				local lint = require("lint")

				lint.linters_by_ft = {
					python = { "flake8" },
					htmldjango = { "djlint" },
				}
				autocmd({ "BufReadPost", "BufWritePost" }, {
					callback = function()
						lint.try_lint({}, { ignore_errors = true })
					end,
				})
			end,
		},
		conform = {
			"stevearc/conform.nvim",
			config = function()
				local conform = require("conform")

				conform.setup({
					formatters_by_ft = {
						python = { "isort", "black" },
						lua = { "stylua" },
					},
					format_on_save = function(bufnr)
						if vim.b[bufnr].disable_autoformat then
							return
						end

						return {}
					end,
				})

				usercmd("FormatDisable", function()
					vim.b.disable_autoformat = true
				end, {
					desc = "Disable autoformat-on-save",
				})
				usercmd("FormatEnable", function()
					vim.b.disable_autoformat = false
				end, {
					desc = "Re-enable autoformat-on-save",
				})
			end,
		},
		treesitter = {
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					auto_install = true,
					highlight = { enable = true },
				})
			end,
		},
		treesitter_context_comment = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			init = function()
				vim.g.skip_ts_context_commentstring_module = true
			end,
		},
		treesitter_context = {
			"nvim-treesitter/nvim-treesitter-context",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			config = function()
				require("treesitter-context").setup({
					max_lines = 5,
					min_window_height = 25,
					multiline_threshold = 5,
					trim_scope = "inner",
					mode = "topline",
					separator = "-",
				})
			end,
		},
		dracula = {
			"Mofiqul/dracula.nvim",
			config = function()
				vim.cmd.colorscheme("dracula")
			end,
		},
		devicons = {
			"nvim-tree/nvim-web-devicons",
			dependencies = { "Mofiqul/dracula.nvim" },
			config = function()
				require("nvim-web-devicons").setup()
			end,
		},
		indent_guides = {
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("ibl").setup({
					scope = {
						show_start = false,
						show_end = false,
						highlight = "LineNr",
					},
				})
			end,
		},
		lualine = {
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				local FT_TS_Component = require("lualine.components.filetype"):extend()
				-- based on ts_context_commentstring/utils.lua:get_node_at_cursor_start_of_line
				function FT_TS_Component.get_ts_lang()
					-- check if treesitter is active and get top level language tree
					local ok, language_tree = pcall(vim.treesitter.get_parser, 0)
					if not ok then
						return
					end

					-- get cursor position as range
					local cursor = vim.api.nvim_win_get_cursor(0)
					local first_non_whitespace_col = vim.fn.match(vim.fn.getline("."), "\\S")
					local range = {
						cursor[1] - 1,
						first_non_whitespace_col,
						cursor[1] - 1,
						first_non_whitespace_col,
					}

					-- Get the smallest supported language's tree with nodes inside the given range
					language_tree:for_each_tree(function(_, ltree)
						if ltree:contains(range) then
							language_tree = ltree
						end
					end)

					if not language_tree then
						return
					end

					return language_tree:lang()
				end

				function FT_TS_Component:update_status(is_focused)
					local ft = FT_TS_Component.super.update_status(self, is_focused)
					if not is_focused or not ft then
						return ft
					end

					local ts_lang = self.get_ts_lang()
					if not ts_lang or ft == ts_lang then
						return ft
					end

					return ft .. "." .. ts_lang
				end

				require("lualine").setup({
					-- default sections in the comments
					sections = {
						-- lualine_a = {'mode'},
						-- lualine_b = {'branch', 'diff', 'diagnostics'},
						lualine_b = { "diff", "diagnostics" },
						-- lualine_c = {'filename'},
						lualine_c = {
							{
								"filename",
								path = 3,
								shorting_target = 80,
							},
						},
						-- lualine_x = {'encoding', 'fileformat', 'filetype'},
						lualine_x = { "vim.fn['zoom#statusline']()", "encoding", FT_TS_Component },
						-- lualine_y = {'progress'},
						-- lualine_z = {'location'}
					},
					inactive_sections = {
						-- lualine_a = {},
						-- lualine_b = {},
						-- lualine_c = {'filename'},
						lualine_c = {
							{
								"filename",
								path = 3,
								shorting_target = 20,
							},
						},
						-- lualine_x = {'location'},
						-- lualine_y = {},
						-- lualine_z = {}
					},
				})
			end,
		},
		bufferline = {
			"akinsho/bufferline.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("bufferline").setup({
					options = {
						mode = "tabs",
					},
				})
			end,
		},
		last_place = {
			"farmergreg/vim-lastplace",
		},
		zoom = {
			"dhruvasagar/vim-zoom",
		},
		leap = {
			"ggandor/leap.nvim",
			config = function()
				require("leap").opts.equivalence_classes = { " \t\r\n", "([{<", ")]}>", "'\"`" }

				map.nmap("s", "<Plug>(leap)")
				map.nmap("S", "<Plug>(leap-from-window)")
				map.map({ "x", "o" }, "s", "<Plug>(leap-forward)")
				map.map({ "x", "o" }, "S", "<Plug>(leap-backward)", { unique = false })
			end,
		},
		undotree = {
			"mbbill/undotree",
			config = function()
				vim.g.undotree_WindowLayout = 3
				vim.g.undotree_SplitWidth = 40
			end,
		},
		highlight_undo = {
			"tzachar/highlight-undo.nvim",
			config = function()
				require("highlight-undo").setup({
					undo = {
						hlgroup = "TermCursor",
					},
					redo = {
						hlgroup = "TermCursor",
					},
				})
			end,
		},
		fundo = {
			"kevinhwang91/nvim-fundo",
			dependencies = { "kevinhwang91/promise-async" },
			config = function()
				require("fundo").setup()
			end,
		},
		telescope = {
			"nvim-telescope/telescope.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				local actions = require("telescope.actions")

				require("telescope").setup({
					defaults = {
						selection_strategy = "follow",
						layout_strategy = "vertical",
						layout_config = {
							width = 0.85,
							preview_cutoff = 0,
							preview_height = 10,
						},
						dynamic_preview_title = true,
						path_display = { shorten = 5 },
						vimgrep_arguments = {
							"rg",
							"--color=never",
							"--no-heading",
							"--with-filename",
							"--line-number",
							"--column",
							"--smart-case",
							-- all above are defaults
							"--trim",
						},
						mappings = {
							i = {
								["<C-N>"] = actions.cycle_history_next,
								["<C-B>"] = actions.cycle_history_prev,
								["<S-Up>"] = actions.results_scrolling_up,
								["<S-Down>"] = actions.results_scrolling_down,
								["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
								["<esc>"] = actions.close,
							},
						},
					},
					pickers = {
						find_files = {
							path_display = "smart",
						},
						live_grep = {
							mappings = {
								i = {
									["<c-f>"] = actions.to_fuzzy_refine,
								},
							},
						},
						grep_string = {
							mappings = {
								i = {
									["<c-f>"] = actions.to_fuzzy_refine,
								},
							},
						},
					},
					extensions = {
						smart_open = {
							match_algorithm = "fzf",
						},
					},
				})

				local builtin = require("telescope.builtin")
				map.nnoremap("<leader>h", function()
					builtin.find_files({ cwd = "~/", hidden = true })
				end)
				map.nnoremap("<leader>g", builtin.live_grep)
				map.nnoremap("<leader>p", function()
					builtin.live_grep({ type_filter = "py" })
				end)
				map.nnoremap("<leader>s", builtin.grep_string)
				map.nnoremap("<leader>w", function()
					builtin.grep_string({ word_match = "-w" })
				end)
				map.nnoremap("<leader><leader>", builtin.resume, { unique = false })
				map.nnoremap("<Leader>r", builtin.lsp_references)
			end,
		},
		telescope_fzf = {
			"nvim-telescope/telescope-fzf-native.nvim",
			dependencies = { "nvim-telescope/telescope.nvim" },
			build = "make",
			config = function()
				require("telescope").load_extension("fzf")
			end,
		},
		{
			"danielfalk/smart-open.nvim",
			dependencies = {
				"kkharji/sqlite.lua",
				"nvim-telescope/telescope-fzf-native.nvim",
			},
			config = function()
				require("telescope").load_extension("smart_open")

				map.nnoremap("<leader>f", function()
					require("telescope").extensions.smart_open.smart_open({ filename_first = false, cwd_only = true })
				end)
			end,
		},
	}),
	{
		defaults = {
			version = "*",
		},
	}
)

-- Force saving files that require root permissions
-- WARNING works only if sudo doesn't have to ask for password (https://github.com/neovim/neovim/issues/1716)
map.cnoremap_colon_prefix("w!!", "w !sudo tee > /dev/null %")

-- easy tabedit/split/vsplit relative to the directory of the current buffer
map.cnoremap_colon_prefix("tt", "tabedit '.expand('%:h').'/")
map.cnoremap_colon_prefix("ss", "split '.expand('%:h').'/")
map.cnoremap_colon_prefix("vv", "vsplit '.expand('%:h').'/")

-- easy going up in dirs
map.cnoremap_colon("..", "../")
map.cnoremap_colon("...", "../../")
map.cnoremap_colon("....", "../../../")
map.cnoremap_colon(".....", "../../../../")

-- Smart Home
map.noremap_silent_expr({ "n", "v" }, "<Home>", "col('.') == match(getline('.'),'\\S')+1 ? 'g0' : 'g^'")
map.inoremap_silent_expr("<Home>", "col('.') == match(getline('.'),'\\S')+1 ? '<C-O>g0' : '<C-O>g^'")

-- Treat long lines as break lines (useful when moving around in them)
map.nnoremap("<Up>", "g<Up>")
map.vnoremap("<Up>", "g<Up>")
map.inoremap("<Up>", "<C-O>g<Up>")
map.nnoremap("<Down>", "g<Down>")
map.vnoremap("<Down>", "g<Down>")
map.inoremap("<Down>", "<C-O>g<Down>")
map.nnoremap("<End>", "g<End>")
map.vnoremap("<End>", "g<End>")
map.inoremap("<End>", "<C-O>g<End>")
map.nnoremap("j", "gj")
map.vnoremap("j", "gj")
map.nnoremap("k", "gk")
map.vnoremap("k", "gk")

-- Search for visual selection
map.vnoremap("//", 'y/\\c\\V<C-R>"<CR>')

-- Search mappings: These will make it so that going to the next one in a search will center on the line it's found in.
map.map({ "n", "v" }, "N", "Nzz")
map.map({ "n", "v" }, "n", "nzz")

-- PageUp/PageDown should move 10 lines
map.nnoremap("<S-Up>", "10<C-U>")
map.imap("<S-Up>", "<C-O><S-Up>")
map.nnoremap("<S-Down>", "10<C-D>")
map.imap("<S-Down>", "<C-O><S-Down>")

-- moving between tabs
map.nnoremap("<S-C-Left>", "gT")
map.inoremap("<S-C-Left>", "<C-O>gT")
map.nnoremap("<S-C-Right>", "gt")
map.inoremap("<S-C-Right>", "<C-O>gt")

-- enter command line mode with semi-colon
map.noremap({ "n", "v" }, ";", ":")

-- quickly repeat last command on command line
map.noremap({ "n", "v" }, ";;", ":<Up>")

-- quickly select just pasted text
map.nnoremap("gV", "`[v`]")

-- Delete trailing whitespace on save, useful for Python, Lua
autocmd("BufWrite", {
	pattern = { "*.py", "*.lua" },
	command = 'silent! keepjumps execute ":%s/\\\\s\\\\+$//ge"',
})

-- recognize requirements.txt filetype
autocmd("BufReadPost", {
	pattern = { "*requirements*.txt" },
	command = "set filetype=requirements",
})
