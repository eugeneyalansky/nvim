return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },
  config = function()
    local lsp = require 'lspconfig'

    lsp.gleam.setup {
      -- Gleam setup
    }

    lsp.pyright.setup {
      -- Python lsp setup
    }

    lsp.lua_ls.setup {
      -- Lua lsp setup
    }
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        map('<leader>lr', vim.lsp.buf.rename, '[L]sp [R]ename')
        map('<leader>la', vim.lsp.buf.code_action, '[L]sp [A]ction', { 'n', 'x' })

        map('<leader>fds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>fws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')



        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>lh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[Lsp] toggle Inlay [H]elp')
        end
      end,
    })

    local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
    local diagnostic_signs = {}
    for type, icon in pairs(signs) do
      diagnostic_signs[vim.diagnostic.severity[type]] = icon
    end
    vim.diagnostic.config { signs = { text = diagnostic_signs } }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- local servers = {
    --   pyright = {},
    --   lua_ls = {
    --     -- cmd = {...},
    --     -- filetypes = { ...},
    --     -- capabilities = {},
    --     settings = {
    --       Lua = {
    --         completion = {
    --           callSnippet = 'Replace',
    --         },
    --       },
    --     },
    --   },
    -- }
    --
    -- require('mason').setup()
    --
    -- -- You can add other tools here that you want Mason to install
    -- -- for you, so that they are available from within Neovim.
    -- local ensure_installed = vim.tbl_keys(servers or {})
    -- vim.list_extend(ensure_installed, {
    --   'stylua', -- Used to format Lua code
    -- })
    -- require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    --
    -- require('mason-lspconfig').setup {
    --   handlers = {
    --     function(server_name)
    --       local server = servers[server_name] or {}
    --       -- This handles overriding only values explicitly passed
    --       -- by the server configuration above. Useful when disabling
    --       -- certain features of an LSP (for example, turning off formatting for ts_ls)
    --       server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
    --       require('lspconfig')[server_name].setup(server)
    --     end,
    --   },
    -- }
  end,
}
