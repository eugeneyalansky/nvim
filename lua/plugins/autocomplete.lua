return { -- Autocompletion
	'hrsh7th/nvim-cmp',
	event = 'InsertEnter',
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-path',
		'lukas-reineke/cmp-under-comparator',
		'L3MON4D3/LuaSnip',
		'rafamadriz/friendly-snippets',
		'saadparwaiz1/cmp_luasnip',
		-- 'saadparwaiz1/cmp_luasnip',
	},
	config = function()
		local cmp = require 'cmp'
		local under_cmp = require 'cmp-under-comparator'
		local luasnip = require 'luasnip'
		luasnip.config.setup {}

		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup {
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = { completeopt = 'menu,menuone,noinsert' },
			sorting = {
				comparators = {
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.score,
					under_cmp.under,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				}
			},
			mapping = cmp.mapping.preset.insert {
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-y>'] = cmp.mapping.confirm { select = true },

				-- ['<CR>'] = cmp.mapping.confirm { select = true },
				['<C-Space>'] = cmp.mapping.complete {},

				-- Think of <c-l> as moving to the right of your snippet expansion.
				--  So if you have a snippet that's like:
				--  function $name($args)
				--    $body
				--  end
				--
				-- <c-l> will move you to the right of each of the expansion locations.
				-- <c-h> is similar, except moving you backwards.
				['<C-l>'] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { 'i', 's' }),
				['<C-h>'] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { 'i', 's' }),
				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
			},
			sources = {
				{ -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
					name = 'lazydev',
					group_index = 0,
				},
				{ name = 'nvim_lsp' },
				{ name = 'path' },
				{ name = 'luasnip' },
			},
		}
	end,
}
