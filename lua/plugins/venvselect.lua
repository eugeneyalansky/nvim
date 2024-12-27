return {
	'AckslD/swenv.nvim',
	setup = function()
		local swenv = require('swenv.api')
		vim.keymap.set('n', '<leader>sv', swenv.pick_env())
	end
}
