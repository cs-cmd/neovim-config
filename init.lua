-- Most of this was taken from 'nvim-lua/kickstart.nvim'
-- "¯\_(ツ)_/¯"
-- Set space as `leader` key
-- Must come before plugins are used
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Fonts need to be installed; change to false if this doesn't work
vim.g.have_nerd_font = false

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- [A]llow mouse
vim.opt.mouse = 'a'

vim.opt.showmode = true

-- allow neovim to use OS clipboard
vim.opt.clipboard = 'unnamedplus'

-- indent with linebreak
vim.opt.breakindent = true

-- save undo history
vim.opt.undofile = true

-- case-insensitive search, unless \C is used
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- keep signcolumn on
vim.opt.signcolumn = 'yes'

-- decrease update time
vim.opt.updatetime = 250

-- decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- new split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- certain whitespace characters display behavior
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- live substitutions preview
vim.opt.inccommand = 'split'

-- highlight line cursor is on
vim.opt.cursorline = true

-- minimum number of screen lines to keep above/below cursor
vim.opt.scrolloff = 10

-- [[ BASIC KEYMAPS ]]
-- highlight search, then clear (normal mode)
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- diagnostics, bound to diagnostic menu option
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', '<leader>dm', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- exit terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disabled arrow keys :)
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move left :)"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move right :)"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move up :)"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move down :)"<CR>')

-- move between windows faster
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to right window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to above window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to below window' })

-- [[ BASIC AUTOCOMMANDS ]]
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking/copying text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- [[ Use lazy.nvim plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
-- useful commands:
-- :Lazy - current plugin status
-- :Lazy update - update plugins

require('lazy').setup({
        'tpope/vim-sleuth', -- detect tabstop and shiftwidth automatically

        -- quickly comment
        -- important keybinds (normal mode):
        -- gcc - line comment
        -- -- gbc - block comment
        { 'numToStr/Comment.nvim', opts = {}, lazy = false },

        -- gitsigns provide signs to gutter for managing changes
        {
            'lewis6991/gitsigns.nvim',
            opts = {
                signs = {
                    add = { text = '+' },
                    change = { text = '~' },
                    delete = { text = '_' },
                    topdelete = { text = '‾' },
                    changedelete = { text = '~' },
                },
            },
        },

        -- shows pending keybinds
        -- {
        --     'folke/which-key.nvim',
        --     event = 'VimEnter', -- load when program is entered
        --     config = function() -- config runs after load
        --         local which = require('which-key')
        --         which.setup()
        --
        --         -- document existing registers
        --         which.register {
        --             ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        --             ['<leader>d'] = { name = '[D]iagnostic', _ = 'which_key_ignore' },
        --             ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        --             ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        --             ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
        --         }
        --     end,
        -- },

        -- fuzzy finder (searches EVERYTHING)
        -- important keybinds:
        --  <C-/> insert mode find
        --  ? normal mode find
        {
            'nvim-telescope/telescope.nvim',
            event = 'VimEnter',
            branch = '0.1.x',
            dependencies = {
                'nvim-lua/plenary.nvim',
                {
                    'nvim-telescope/telescope-fzf-native.nvim',
                    build = 'make',
                    -- determine if plugin should be loaded
                    cond = function()
                        return vim.fn.executable 'make' == 1
                    end
                },
                { 'nvim-telescope/telescope-ui-select.nvim' },
                { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
            },
            config = function()
                -- load keybinds here
                extensions = {
                        ['ui-select'] = {
                            require('telescope.themes').get_dropdown(),
                        },
                    },

                    -- enable extensions if installed
                    pcall(require('telescope').load_extension, 'fzf')
                pcall(require('telescope').load_extension, 'ui-select')

                -- fzf keybinds
                local builtin = require('telescope.builtin')
                vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
                vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
                vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
                vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
                vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
                vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
                vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
                vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
                vim.keymap.set('n', '<leader>s', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
                vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

                vim.keymap.set('n', '<leader>/', function()
                    -- can change themes
                    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                        winblend = 10,
                        previewer = false,
                    })
                end, { desc = '[/] Fuzzily search in current buffer' })

                vim.keymap.set('n', '<leader>s/', function()
                    builtin.live_grep {
                        grep_open_files = true,
                        prompt_title = 'Live Grep in Open Files',
                    }
                end, { desc = '[S]earch [/] in Open Files' })

                -- search neovim config files
                vim.keymap.set('n', '<leader>sn', function()
                    builtin.find_files { cwd = vim.fn.stdpath 'config' }
                end, { desc = '[S]earch [N]eovim files' })
            end, -- config
        },       -- telescope

        {
            'neovim/nvim-lspconfig',
            dependencies = {
                -- install LSP and related tools to stdpath
                'williamboman/mason.nvim',
                'williamboman/mason-lspconfig.nvim',
                'WhoIsSethDaniel/mason-tool-installer.nvim',

                -- Status updates for LSP
                { 'j-hui/fidget.nvim', opts = {} },

                -- Lua LSP
                { 'folke/neodev.nvim', opts = {} },
            },
            config = function()
                vim.api.nvim_create_autocmd('LspAttach', {
                    -- Languiage Server Protocol
                    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                    callback = function(event)
                        local builtin = require('telescope.builtin')

                        -- Helper to define LSP-related functions
                        local map = function(keys, func, desc)
                            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                        end

                        -- Jump to definition
                        map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')

                        -- Find references under cursor
                        map('gr', builtin.lsp_references, '[G]oto [R]eferences')

                        -- Jump to implementation
                        map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')

                        -- Jump to definition of type
                        map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
                        -- Fzf all symbols in current document
                        map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')

                        -- Fzf sumbols in current workspace
                        map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                        -- rename variable underneath cursor
                        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

                        -- allow for code action, such as correcting an error
                        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                        -- display documentation of word under cursor
                        -- `:help K` to view reason for this keybind
                        map('K', vim.lsp.buf.hover, 'Hover Documentation')

                        -- view declaration, not definition, of item
                        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                        -- highlight words like the one under cursor, clear when move
                        local client = vim.lsp.get_client_by_id(event.data.client_id)
                        if client and client.server_capabilities.documentHightlightProvider then
                            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                                buffer = event.buf,
                                callback = vim.lsp.buf.document_highlight,
                            })

                            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                                buffer = event.buf,
                                callback = vim.lsp.buf.clear_references,
                            })
                        end -- if client
                    end,    -- callback
                })

                -- create additional capabilites with nvim-cmp, luasnap, etc
                local capabilites = vim.lsp.protocol.make_client_capabilities()
                capabilites = vim.tbl_deep_extend('force', capabilites, require('cmp_nvim_lsp').default_capabilities())

                local servers = {
                    clangd = {},
                    gopls = {},
                    rust_analyzer = {},
                    tsserver = {},
                    lua_ls = {
                        settings = {
                            Lua = {
                                completion = {
                                    callSnippet = 'Replace'
                                },
                            },
                        },
                    },
                } -- servers

                require('mason').setup()

                local ensure_installed = vim.tbl_keys(servers or {})
                vim.list_extend(ensure_installed, {
                    'stylua',
                })
                require('mason-tool-installer').setup { ensure_installed = ensure_installed }

                require('mason-lspconfig').setup {
                    handlers = {
                        function(server_name)
                            local server = servers[server_name] or {}

                            server.capabilites = vim.tbl_deep_extend('force', {}, capabilites, server.capabilites or {})
                            require('lspconfig')[server_name].setup(server)
                        end,
                    },
                }
            end, -- config
        },       -- LSP

        -- autoformatting
        {
            'stevearc/conform.nvim',
            lazy = false, -- always load
            keys = {
                {
                    '<leader>f',
                    function()
                        require('conform').format { async = true, lsp_fallback = true }
                    end,
                    mode = '',
                    desc = '[F]ormat buffer',
                },
            },
            opts = {
                notify_on_error = false,
                format_on_save = function(bufnr)
                    -- disable formatting for languages without common formatting styles
                    local disable_filetypes = { c = true, cpp = true }
                    return {
                        timeout_ms = 500,
                        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                    }
                end, -- format_on_save
                formatters_by_ft = {
                    lua = { 'stylua' },
                    -- different formatters go here

                },
            },
        },

        -- Autocompletion
        {
            'hrsh7th/nvim-cmp',
            event = 'InsertEnter',
            dependencies = {
                -- snippet engine and associated source
                {
                    'L3MON4D3/LuaSnip',
                    build = (function()
                        -- build step for regex
                        -- not supported in windows environments
                        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                            return
                        end -- if
                        return 'make install_jsregexp'
                    end)(), -- build
                    dependencies = {
                        -- friend
                    }
                },
                'saadparwaiz1/cmp_luasnip',

                -- Adds other completion capabilites
                -- Split into several repos for maintainability
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-path',
            },
            config = function()
                -- `:help cmp`
                local cmp = require 'cmp'
                local luasnip = require 'luasnip'
                luasnip.config.setup {}

                cmp.setup {
                    snippet = {
                        expand = function(args)
                            luasnip.lsp_expand(args.body)
                        end, -- expand
                    },
                    completion = { completeopt = 'menu,menuone,noinsert' },

                    -- `:help ins-completion`
                    mapping = cmp.mapping.preset.insert {
                        -- [N]ext item
                        ['<C-n>'] = cmp.mapping.select_next_item(),
                        -- [P]revious item
                        ['<C-p'] = cmp.mapping.select_prev_item(),
                        -- Scroll documentation [B]ack/[F]orward
                        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                        ['<C-f>'] = cmp.mapping.scroll_docs(4),

                        -- Confirm completion
                        ['<C-Space>'] = cmp.mapping.confirm { select = true },

                        -- Manually trigger completion from nvim-cmp
                        ['<C-y>'] = cmp.mapping.complete {},


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
                    },
                    sources = {
                        { name = 'nvim_lsp' },
                        { name = 'luasnip' },
                        { name = 'path' },
                    },
                }
            end, -- config
        },
        {
            'folke/todo-comments.nvim',
            event = 'VimEnter',
            dependencies = {
                'nvim-lua/plenary.nvim',
            },
            opts = {
                signs = false,
            }
        },

        {
            'nvim-treesitter/nvim-treesitter',
            build = ':TSUpdate',
            opts = {
                ensure_installed = { 'bash', 'c', 'cpp', 'html', 'css', 'javascript', 'typescript', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'rust', 'go' },
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { 'ruby' },
                },
                indent = { enable = true, disable = { 'ruby' } },
            },
            config = function(_, opts)
                -- `:help nvim-treesitter`
                ---@diagnostic disable-next-line: missing-fields
                require('nvim-treesitter.configs').setup(opts)
            end, -- config
        },

        {
            'nvim-tree/nvim-tree.lua',
            version = '*',
            lazy = false,
            dependencies = {
                'nvim-tree/nvim-web-devicons',
            },
            config = function()
                require('nvim-tree').setup {} -- setup
                local api = require('nvim-tree.api')
                local function opts(desc)
                    return { desc = 'nvim-tree: ' .. desc, buffer = burnr, noremap = true, silent = true, nowait = true }
                end -- opts

                -- api.config.mappings.default_on_attach(bufnr)

                vim.keymap.set('n', '<leader>tt', api.tree.toggle, opts('Toggle tree'))
            end, -- config
        },

        -- [[ COLORSCHEMES ]]
        {
            'folke/tokyonight.nvim',
            priority = 1000, -- load before other plugins
        },

        {
            'thedenisnikulin/vim-cyberpunk',
            priority = 1000,
            init = function()
                vim.cmd.colorscheme 'cyberpunk'
                vim.cmd.set 'termguicolors'
            end,
        },

        {
            'Zabanaa/neuromancer.vim',
            priority = 1000,
        },

    },
    {
        ui = {
            icons = vim.g.have_nerd_font and {} or {
                cmd = '⌘',
                config = '🛠',
                event = '📅',
                ft = '📂',
                init = '⚙',
                keys = '🗝',
                plugin = '🔌',
                runtime = '💻',
                require = '🌙',
                source = '📄',
                start = '🚀',
                task = '📌',
                lazy = '💤 ',
            }
        },
    })
