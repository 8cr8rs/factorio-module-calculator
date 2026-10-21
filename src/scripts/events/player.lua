-- SPDX-FileCopyrightText: 2026 eightcraters <eightcraters@hotmail.com>
-- SPDX-License-Identifier: Apache-2.0

local defines_events = defines.events

local gui = require("scripts.gui")

script.on_event(defines_events.on_player_joined_game, function(event)
  local player = game.get_player(event.player_index)
  if not (player and player.valid) then
    return
  end
  gui.build(player)
end)

script.on_event(defines_events.on_player_left_game, function(event)
  local player = game.get_player(event.player_index)
  if not (player and player.valid) then
    return
  end
  gui.destroy(player)
end)


script.on_event(defines_events.on_gui_click, function(event)
  if event.element and event.element.name == "mcalc_close_button" then
    local player = game.get_player(event.player_index)
    gui.set_visible(player, false)
  end
end)
