-- SPDX-FileCopyrightText: 2026 eightcraters <eightcraters@hotmail.com>
-- SPDX-License-Identifier: Apache-2.0

script.on_event("mcalc-get-selection-tool", function(event)
  local player = game.get_player(event.player_index)
  if not (player and player.valid) then
    return
  end
  local cs = player.cursor_stack
  -- valid_for_read is just a signal for whether or not the stack contains an
  -- item. It has no relation to dangling pointers.
  if not cs.valid or (cs.valid_for_read and not player.clear_cursor()) then
    return
  end
  cs.set_stack({ name = "mcalc-selection-tool" })
end)
