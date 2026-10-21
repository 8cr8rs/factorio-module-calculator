-- SPDX-FileCopyrightText: 2026 eightcraters <eightcraters@hotmail.com>
-- SPDX-License-Identifier: Apache-2.0

-- change this to include any machine that is affected by beacons
local selection_entity_type_filters = {
  "beacon",
  "crafting-machine",
}

data:extend({
  {
    type = "selection-tool",
    name = "mcalc-selection-tool",
    stack_size = 1,
    hidden = true,
    auto_recycle = false,
    flags = {
      "only-in-cursor",
      "not-stackable",
      "spawnable"
    },
    icon = "__module-calculator__/graphics/item/test.png",
    select = {
      mode = { "buildable-type", "friend" },
      entity_type_filters = selection_entity_type_filters,
      cursor_box_type = "entity",
      border_color = { r = 1, g = 0, b = 1 },
    },
    alt_select = {
      mode = { "buildable-type", "friend" },
      entity_type_filters = selection_entity_type_filters,
      cursor_box_type = "entity",
      border_color = { r = 1, g = 0, b = 1 },
    },
    reverse_select = {
      mode = { "buildable-type", "friend" },
      entity_type_filters = selection_entity_type_filters,
      cursor_box_type = "not-allowed",
      border_color = { r = 1, g = 1, b = 1 },
    },
    alt_reverse_select = {
      mode = { "buildable-type", "friend" },
      entity_type_filters = selection_entity_type_filters,
      cursor_box_type = "not-allowed",
      border_color = { r = 1, g = 1, b = 1 },
    },
  }
})
