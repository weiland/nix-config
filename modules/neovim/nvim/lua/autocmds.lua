-- Highlight selection on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.highlight.on_yank() end,
    desc = "Briefly highlight selection on yank."
})

-- Return to last edit position when opening files (instead of relativenumbers)
-- local api = vim.api
-- local cmd = vim.cmd
-- api.nvim_create_autocmd('BufReadPost', {
--     group = vim.g.user.event,
--     callback = function(args)
--         local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
--         local not_commit = vim.b[args.buf].filetype ~= 'commit'

--         if valid_line and not_commit then
--             cmd([[normal! g`"]])
--         end
--     end,
--     desc = "Jump to the last known and valid cursor position (when not in commit)."
-- })
