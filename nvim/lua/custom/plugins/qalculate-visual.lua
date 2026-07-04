QalculateVisual = {}
local function ExtractSelectionRegion()
  local mode = vim.api.nvim_get_mode()
  if mode.mode ~= 'v' then
    return nil, nil, 'qualculate-visual: Only works in visual mode not even in visual block or visual line mode'
  else
    local startPos = vim.fn.getpos '.'
    local endPos = vim.fn.getpos 'v'

    if startPos[2] > endPos[2] or (startPos[2] == endPos[2] and startPos[3] > endPos[3]) then
      startPos, endPos = endPos, startPos
    end

    return startPos, endPos, nil
  end
end

local function Qalculate(startPos, endPos)
  local txt = ''
  local region = vim.fn.getregion(startPos, endPos)
  for _, value in ipairs(region) do
    txt = txt .. value .. ' '
  end
  local err = nil
  local res = vim.system({ 'qalc', '-novariables', '-nocurrencies', '-t', vim.fn.shellescape(txt) }):wait()
  local output = vim.trim(res.stdout)
  err = res.stderr
  vim.notify(output, vim.log.INFO)
  return output, err, startPos, endPos
end

function QalculateVisual.QalculateAndYank()
  local startPos, endPos, err = ExtractSelectionRegion()
  if err ~= nil then
    vim.notify(err, vim.log.ERROR)
    return
  end
  local output, err, _, _ = Qalculate(startPos, endPos)
  if err ~= '' then
    vim.notify(err, vim.log.ERROR)
    return
  end
  vim.fn.setreg('+', output)
  vim.fn.setreg('*', output)
  vim.fn.setreg('"', output)
end

function QalculateVisual.QalculateAndPaste()
  local startPos, endPos, err = ExtractSelectionRegion()
  if err ~= nil then
    vim.notify(err, vim.log.ERROR)
    return
  end
  local output, err, _, _ = Qalculate(startPos, endPos)
  if err ~= '' then
    vim.notify(err, vim.log.ERROR)
    return
  end
  local start_row = startPos[2] - 1
  local start_col = startPos[3] - 1
  local end_row = endPos[2] - 1
  local end_col = endPos[3]

  vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, { output })
end

return QalculateVisual
