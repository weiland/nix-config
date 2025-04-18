local cmd, g, b, w = vim.cmd, vim.g, vim.b, vim.w
local function map(lhs, rhs)
    vim.api.nvim_set_keymap('n', '<leader>' .. lhs, rhs, {noremap=true, silent=true})
end

require('fidget').setup({
  text = {
    spinner = 'dots_negative',
  },
  window = {
    blend = 0,
  },
})

vim.g.code_action_menu_show_diff = false

-- lsp-status
local lsp_status = require('lsp-status')
lsp_status.register_progress()
lsp_status.config({
  diagnostics = false,
  current_function = false,
  status_symbol = ''
})

-- neogit
local neogit = require('neogit')
neogit.setup({})

require('Comment').setup()

require('ibl').setup {
  scope = {
    show_start = false
  }
}

-- easy-align
vim.api.nvim_set_keymap("x", "<leader>a", "<Plug>(EasyAlign)", {})
vim.api.nvim_set_keymap("n", "<leader>a", "<Plug>(EasyAlign)", {})

-- luasnip
local ls = require("luasnip")
ls.add_snippets("all", {
	ls.snippet("todo", {
    ls.text_node("TODO(pascal): "),
	})
})
vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})

-- null-ls
local eslint_options = {
        condition = function(utils)
            return utils.root_has_file({ ".eslintrc.json", ".eslintrc.cjs", ".eslintrc.js", ".eslintrc" })
        end,
    }
local prettierd_options = {
        condition = function(utils)
            return utils.root_has_file({ ".prettierrc.json", ".prettierrc.cjs", ".prettierrc.js", ".prettierrc" })
        end,
    }
local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    -- js,ts,etc.
    -- null_ls.builtins.formatting.prettierd.with(prettierd_options), -- daemon continues to run
    -- null_ls.builtins.diagnostics.eslint,
    -- null_ls.builtins.formatting.eslint_d.with(eslint_options),
    -- null_ls.builtins.diagnostics.eslint_d.with(eslint_options),
    -- null_ls.builtins.code_actions.eslint_d.with(eslint_options),

    -- shell
    -- null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.formatting.fish_indent,
    -- null_ls.builtins.diagnostics.shellcheck,

    -- Nix
    null_ls.builtins.code_actions.statix,

    -- Elixir
    null_ls.builtins.diagnostics.credo,

    -- gitlint
    null_ls.builtins.diagnostics.gitlint,

    -- markdown, text (cargo install languagetool-rust --features full)
    -- null_ls.builtins.code_actions.ltrs, -- disabled due to 1500 text limit
  },
  on_attach = require('lsp').on_attach
})

-- comes from denols
vim.g.markdown_fenced_languages = {
  "ts=typescript"
}

-- nil_ls setup using lspconfig
local lspconfig = require('lspconfig')
local capabilities = require('lsp').capabilities(),
lspconfig.nil_ls.setup({
  autostart = true,
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    require('lsp').on_attach(client, bufnr)
  end,
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixpkgs-fmt" }
      },
    },
  },
})

-- deno
local util = require 'lspconfig.util'
lspconfig.denols.setup({
  on_attach = require('lsp').on_attach,
  root_dir = util.root_pattern("deno.json", "deno.jsonc"),
})

-- lspconfig.ts_ls.setup({
--   capabilities = capabilities,
--   on_attach = require('lsp').on_attach,
--   root_dir =  util.root_pattern('package.json'),
--   single_file_support = false,
-- })

lspconfig.svelte.setup({
  on_attach = require('lsp').on_attach,
  -- root_dir =  util.root_pattern('svelte.config.js'),
})

lspconfig.bashls.setup{}

lspconfig.eslint.setup{}

lspconfig.ts_ls.setup{
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/Users/pw/src/clones/language-tools/packages/typescript-plugin",
        languages = {"javascript", "typescript", "vue"},
      },
    },
  },
  filetypes = {
    "javascript",
    "typescript",
    "vue",
  },
}

lspconfig.volar.setup{}

lspconfig.astro.setup{}

-- generate help tags for all plugins
cmd 'silent! helptags ALL'
cmd 'unmap Y'

-- headlines (config with nord theme)
require('headlines').setup({
    markdown = {
    headline_highlights = {
            'Headline1',
            'Headline2',
            'Headline3',
            'Headline4',
            'Headline5',
            'Headline6',
        },
        codeblock_highlight = 'CodeBlock',
        dash_highlight = 'Dash',
        fat_headline_upper_string = "▃",
        fat_headline_lower_string = 'ﮋ', -- "▀", -- "🬂", cannot be displayed :c
        quote_highlight = 'Quote',
    },
})

-- Spelling
-- Correct current word
vim.keymap.set('n', 'z=',
  function()
    require('telescope.builtin').spell_suggest()
  end
)
map('sl', ':lua cyclelang()<cr>') --Change spelling language
do
    local i = 1
    local langs = {'', 'en', 'de'}
    function cyclelang()
        i = (i % #langs) + 1     -- update index
        b.spelllang = langs[i]   -- change spelllang
        w.spell = langs[i] ~= '' -- if empty then nospell
    end
end
