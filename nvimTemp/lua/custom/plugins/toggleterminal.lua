local TerminalToggler = {}

local state = { win = nil, buf = nil }

vim.api.nvim_create_autocmd('TermClose', {
  callback = function(ev)
    if ev.buf == state.buf then
      vim.cmd 'startinsert'
      state.buf = nil
      state.win = nil
      vim.schedule(function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', false)
      end)
    end
  end,
})

vim.api.nvim_create_autocmd('WinClosed', {
  callback = function(args)
    if args.id == state.win then
      state.win = nil
      state.buf = nil
    end
  end,
})

function TerminalToggler.toggle()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
    state.buf = nil
    return
  end
  vim.cmd 'belowright split'
  state.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_height(state.win, 8)
  -- if not state.buf then
  state.buf = vim.api.nvim_create_buf(false, true)
  -- vim.bo[state.buf].bufhidden = 'hide'
  vim.api.nvim_win_set_buf(state.win, state.buf)
  vim.fn.jobstart(vim.o.shell, { term = true, buf = state.buf })
  vim.cmd 'startinsert'
  -- vim.cmd 'a'
  -- end
end

return TerminalToggler
