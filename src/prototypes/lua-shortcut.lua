-- SPDX-FileCopyrightText: 2026 eightcraters <eightcraters@hotmail.com>
-- SPDX-License-Identifier: Apache-2.0

local shortcut_path = "__module-calculator__/graphics/icon/shortcut-toolbar/mip/module-calculator"

data:extend({
  {
    type = "shortcut",
    name = "mcalc-toggle-gui",
    action = "lua",
    icon = table.concat({ shortcut_path, "-x56.png" }, ""),
    small_icon = table.concat({ shortcut_path, "-x24.png" }, ""),
    icon_size = 56,
    small_icon_size = 24,
  }
})
