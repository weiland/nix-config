local cmd = vim.cmd

-- Highlight selection on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
  desc = "Briefly highlight selection on yank."
})

-- Return to last edit position when opening files (instead of relativenumbers)
-- autocmd BufReadPost *
--      \ if line("'\"") > 0 && &filetype != "gitcommit" && line("'\"") <= line("$") |
--      \   exe "normal! g`\"" |
--      \ endif

local api = vim.api
api.nvim_create_autocmd({ 'BufRead', 'BufReadPost' }, {
  callback = function()
    local row, column = unpack(api.nvim_buf_get_mark(0, '"'))
    local buf_line_count = api.nvim_buf_line_count(0)

    if row >= 1 and row <= buf_line_count and vim.bo.filetype ~= "gitcommit" then
      api.nvim_win_set_cursor(0, { row, column })
    end
  end,
  desc = "Remember last cursor position, except for git commits."
})
