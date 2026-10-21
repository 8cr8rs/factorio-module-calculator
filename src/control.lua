-- SPDX-FileCopyrightText: 2026 eightcraters <eightcraters@hotmail.com>
-- SPDX-License-Identifier: Apache-2.0

require("scripts.migrations")

require("scripts.events.input")
require("scripts.events.lua-shortcut")
require("scripts.events.player")

local base_module_names = {
  ["speed-module"]          = true,
  ["speed-module-2"]        = true,
  ["speed-module-3"]        = true,

  ["productivity-module"]   = true,
  ["productivity-module-2"] = true,
  ["productivity-module-3"] = true,

  ["efficiency-module"]     = true,
  ["efficiency-module-2"]   = true,
  ["efficiency-module-3"]   = true,

  ["quality-module"]        = true,
  ["quality-module-2"]      = true,
  ["quality-module-3"]      = true,
}

--- @param module_name string The name of the module
--- @return boolean valid If the name is a vanilla module
local function is_vanilla_module(module_name)
  return not not base_module_names[module_name]
end
