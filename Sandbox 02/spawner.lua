local var = require("/dynamic/variables.lua")
local pew = pewpew

function spawner_new(x,y)
  local id = pew[var.entity](x,y)
  pew[var.entity_mesh](id,var.root.."spawner_graphic"..var.file_end,0)
end
-- var: 3