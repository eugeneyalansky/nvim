return {
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	config = function()
		require 'nvim-treesitter.configs'.setup {
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<leader>v",
					node_incremental = "<C-K>",
					node_decremental = "<C-J>",
					-- scope_incremental = "<C-h>",
				}
			},
			textobjects = {
				-- SELECT
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						['aa'] = '@parameter.outer',
						['ia'] = '@parameter.inner',
						['af'] = '@function.outer',
						['if'] = '@function.inner',
						['ac'] = '@class.outer',
						['ic'] = '@class.inner',
					},
				},
				-- MOVE
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						[']m'] = '@function.outer',
						[']c'] = '@class.outer',
					},
					goto_next_end = {
						[']M'] = '@function.outer',
						[']C'] = '@class.outer',
					},
					goto_previous_start = {
						['[m'] = '@function.outer',
						['[c'] = '@class.outer',
					},
					goto_previous_end = {
						['[M'] = '@function.outer',
						['[C'] = '@class.outer',
					},
				} } }
	end
}
