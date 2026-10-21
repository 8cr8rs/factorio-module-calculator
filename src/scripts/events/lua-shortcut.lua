-- SPDX-FileCopyrightText: 2026 eightcraters <eightcraters@hotmail.com>
-- SPDX-License-Identifier: Apache-2.0

local defines_events = defines.events

local gui = require("scripts.gui")

script.on_event(defines_events.on_lua_shortcut, function(event)
  if event.prototype_name ~= "mcalc-toggle-gui" then
    return
  end
  local player = game.get_player(event.player_index)
  gui.set_visible(player)
end)
