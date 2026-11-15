local C = require("/dynamic/game_config.lua")
local S = require("/dynamic/state.lua")

local P = {}

P.CORRECT = 1
P.CORRUPT = 2

function P.reset()
  S.cells = {}
  for i = 1,C.CELLS do
    S.cells[i] = 0
  end
end

function P.filled()
  local n = 0
  for i = 1,C.CELLS do
    if S.cells[i] ~= 0 then
      n = n+1
    end
  end
  return n
end

function P.correct()
  local n = 0
  for i = 1,C.CELLS do
    if S.cells[i] == P.CORRECT then
      n = n+1
    end
  end
  return n
end

function P.percent()
  return P.filled()*100//C.CELLS
end

function P.correct_percent()
  return P.correct()*100//C.CELLS
end

function P.full()
  return P.filled() >= C.CELLS
end

function P.add_correct(count)
  local added = 0
  for i = 1,C.CELLS do
    if added >= count then
      break
    end
    if S.cells[i] == 0 then
      S.cells[i] = P.CORRECT
      added = added+1
    end
  end
  return added
end

function P.add_corrupt(count)
  local added = 0
  for i = 1,C.CELLS do
    if added >= count then
      break
    end
    if S.cells[i] == 0 then
      S.cells[i] = P.CORRUPT
      added = added+1
    end
  end
  return added
end

function P.remove_last()
  for i = C.CELLS,1,-1 do
    if S.cells[i] ~= 0 then
      S.cells[i] = 0
      return true
    end
  end
  return false
end

function P.fill_all()
  for i = 1,C.CELLS do
    S.cells[i] = P.CORRECT
  end
end

function P.clear_corrupt()
  local removed = 0
  for i = 1,C.CELLS do
    if S.cells[i] == P.CORRUPT then
      S.cells[i] = 0
      removed = removed+1
    end
  end
  return removed
end

function P.corrupt_count()
  local n = 0
  for i = 1,C.CELLS do
    if S.cells[i] == P.CORRUPT then
      n = n+1
    end
  end
  return n
end

return P
