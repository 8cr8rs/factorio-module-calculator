-- SPDX-FileCopyrightText: 2026 eightcraters <eightcraters@hotmail.com>
-- SPDX-License-Identifier: Apache-2.0

-- Settings might be unviable for being non-portable

data:extend({
  {
    -- Whether to take modules in objects as given or not
    type = "bool-setting",
    name = "mcalc-take-selection-as-given",
    setting_type = "runtime-per-user",
    default_value = true,
    order = "aa",
  },
  {
    -- Whether to include modules from mods (e.g: EditorExtensions special
    -- debugging modules)
    type = "bool-setting",
    name = "mcalc-include-modded-modules",
    setting_type = "runtime-per-user",
    default_value = false,
    order = "ab",
  },
  {
    -- Whether to include hidden recipes (e.g: heat interfaces, infinity pipes)
    type = "bool-setting",
    name = "mcalc-include-hidden-recipes",
    setting_type = "runtime-per-user",
    default_value = false,
    order = "ac",
  },
})
