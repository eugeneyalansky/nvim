vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.shiftwidth = 4
vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorline = true

-- Preview substitution
vim.opt.inccommand = 'split'

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = false

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>t', "<cmd>ToggleTerm<cr>")
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '[b', ':bp<CR>', { desc = 'Go to previous buffer' })
vim.keymap.set('n', ']b', ':bn<CR>', { desc = 'Go to next buffer' })
vim.keymap.set('n', '<leader>bq', ':bd<cr>', { desc = 'Close buffer' })


require('config.lazy')


-- Highlight yank
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
