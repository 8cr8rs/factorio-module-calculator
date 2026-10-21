-- SPDX-FileCopyrightText: 2026 eightcraters <eightcraters@hotmail.com>
-- SPDX-License-Identifier: Apache-2.0

-- This whole section is to make renaming each GUI element easier.
-- Each element is prefixed with GUI_PREFIX to prevent collisions with other
-- mods. It also eases setting up event hooks to find those exact elements.
-- e.g: detecting a button press

local defines_events = defines.events

local GUI_PREFIX = "mcalc"

--- @return LuaQualityPrototype[]
local function get_quality_prototypes()
  local quality_prototypes = {}
  for quality_name, quality_prototype in pairs(prototypes.quality) do
    if quality_name ~= "quality-unknown" then
      quality_prototypes[quality_name] = quality_prototype
    end
  end
  return quality_prototypes
end

--- @param stat number
--- @param quality_prototype LuaQualityPrototype
--- @return number quality_stat
local function get_quality_stat(stat, quality_prototype)
  return stat * (1 + quality_prototype.level * 0.3)
end

--- @param elem LuaGuiElement
local function add_quality_selector(elem, quality_prototypes)
  local quality_selector = elem.add({
    type = "flow",
    direction = "horizontal",
    style = "packed_horizontal_flow",
  })
  for quality_name, _ in pairs(quality_prototypes) do
    -- quality-unknown is a reserved value not used in normal circumstances
    quality_selector.add({
      type = "sprite-button",
      sprite = "quality/" .. quality_name,
      mouse_button_filter = { "left" },
      auto_toggle = true,
      toggled = true,
      style = "tool_button",
    })
  end
  return quality_selector
end

-- Props to this style guide from raiguard
-- https://man.sr.ht/~raiguard/factorio-gui-style-guide/

--- @param elem LuaGuiElement
local function add_horizontal_pusher(elem)
  local horizontal_pusher = elem.add({
    type = "empty-widget",
  })
  horizontal_pusher.style.horizontally_stretchable = "on"
  return horizontal_pusher
end

--- @param elem LuaGuiElement
local function add_draggable_space(elem)
  local draggable_space = elem.add({
    type = "empty-widget",
  })
  draggable_space.style.horizontally_stretchable = "on"
  draggable_space.style.height = 24
  draggable_space.style.right_margin = 4
  return draggable_space
end


--- @param s string | nil
local function prefix(s)
  if s then
    return string.format("%s_%s", GUI_PREFIX, s)
  else
    return GUI_PREFIX
  end
end

-- names for the elements
-- you can rename these symbols if needed
-- but prioritize changing the actual string first
local GUI = {
  window       = prefix("window"),
  close_button = prefix("close_button"),
}

local QUALITY_PROTOTYPES = get_quality_prototypes()

local gui = {}

-- config for the gui
-- create a class object of this with the mod config to update the gui
-- effectively
-- GuiSettings is temporarily nil as it is unused
--- @class GuiSettings
--- @field hidden_recipes boolean
--- @field use_modded_modules boolean


--- @param player LuaPlayer
--- @return LuaGuiElement | nil
function gui.get(player)
  if not (player and player.valid) then
    return
  end
  local window = player.gui.screen[GUI.window]
  if not window then
    return
  end
  return window
end


--- @param player LuaPlayer
function gui.destroy(player)
  local window = gui.get(player)
  if not window then
    return
  end
  window.destroy()
end

--- Builds the GUI, overwriting any existing instance of it in the process
--- @param player LuaPlayer
--- @param settings GuiSettings | nil
--- @return LuaGuiElement
function gui.build(player, settings)
  local window = gui.get(player)
  if window then
    gui.destroy(player)
  end

  -- abbreviations:
  -- ct = content (main content containers, etc)
  -- f = flow

  -- The container window
  window = player.gui.screen.add({
    type = "frame",
    name = GUI.window,
    direction = "vertical",
  })
  window.visible = false

  local window_f = window.add({
    type = "flow",
    direction = "horizontal",
  })
  window_f.style.horizontal_spacing = 8
  window_f.drag_target = window

  --
  -- titlebar stuff
  --

  -- The title text
  window_f.add({
    type = "label",
    caption = { "gui.mcalc-title-label" },
    style = "frame_title",
    ignored_by_interaction = true,
  })

  -- this "dragger" is purely visual
  -- the flow is the real dragger
  add_draggable_space(window_f)

  -- Button to close the gui
  window_f.add({
    type = "sprite-button",
    name = GUI.close_button,
    style = "frame_action_button",
    sprite = "utility/close",
    hovered_sprite = "utility/close_black",
  })

  --
  -- container stuff
  --

  local win_ct_f = window.add({
    type = "flow",
    direction = "horizontal",
  })
  win_ct_f.style.horizontal_spacing = 12

  --
  -- configuration container
  --

  local ct_conf = win_ct_f.add({
    type = "frame",
    style = "inside_shallow_frame",
  })
  ct_conf.style.width = 400
  ct_conf.style.height = 600
  local configuration_flow = ct_conf.add({
    type = "flow",
    direction = "vertical",
    style = "inside_deep_frame",
  })

  local ct_conf_subh_frame = configuration_flow.add({
    type = "frame",
    style = "subheader_frame",
  })
  ct_conf_subh_frame.add({
    type = "label",
    style = "subheader_caption_label",
    caption = { "gui.mcalc-configuration-subheader-label" },
  })
  add_horizontal_pusher(ct_conf_subh_frame)

  -- configuration's tabs

  configuration_flow.style.vertical_spacing = 0
  local conf_tabs = configuration_flow.add({
    type = "tabbed-pane",
  })
  local conf_tab_recipe = conf_tabs.add({
    type = "tab",
    caption = { "gui.mcalc-c-tab-recipe-caption" },
  })
  local conf_tab_modules = conf_tabs.add({
    type = "tab",
    caption = { "gui.mcalc-c-tab-modules-caption" },
  })
  local conf_tab_settings = conf_tabs.add({
    type = "tab",
    caption = { "gui.mcalc-c-tab-settings-caption" },
  })

  -- recipes tab

  local conf_tab_recipe_content = conf_tabs.add({
    type = "scroll-pane",
    direction = "vertical",
    vertical_scroll_policy = "auto",
  })

  conf_tab_recipe_content.add({
    type = "choose-elem-button",
    elem_type = "recipe",
    elem_filters = {
      {
        filter = "category",
        category = "crafting",
      }
    },
  })

  -- modules tab

  local conf_tab_modules_content = conf_tabs.add({
    type = "scroll-pane",
    direction = "vertical",
    vertical_scroll_policy = "auto",
  })
  conf_tab_modules_content.add({
    type = "button",
    caption = { "gui.mcalc-c-tab-modules-enable-all" },
  })
  conf_tab_modules_content.add({
    type = "button",
    caption = { "gui.mcalc-c-tab-modules-disable-all" },
  })

  local conf_tab_modules_table = conf_tab_modules_content.add({
    type = "table",
    style = "bordered_table",
    column_count = 1,
  })
  -- move this section OUTSIDE of the build function later
  local module_prototypes = prototypes.get_item_filtered({
    {
      filter = "type",
      type = "module",
    }
  })
  for module_name, _ in pairs(module_prototypes) do
    local horizontal_flow = conf_tab_modules_table.add({
      type = "flow",
      direction = "horizontal",
    })
    horizontal_flow.add({
      type = "sprite",
      sprite = "item/" .. module_name,
      elem_tooltip = {
        type = "item",
        name = module_name,
      },
    })
    add_horizontal_pusher(horizontal_flow)
    add_quality_selector(horizontal_flow, QUALITY_PROTOTYPES)
  end

  -- settings tab

  local conf_tab_settings_content = conf_tabs.add({
    type = "scroll-pane",
    direction = "vertical",
    vertical_scroll_policy = "auto",
  })
  conf_tab_settings_content.add({
    type = "checkbox",
    caption = "1",
  })
  conf_tab_settings_content.add({
    type = "checkbox",
    caption = "2",
  })
  conf_tab_settings_content.add({
    type = "checkbox",
    caption = "3",
  })

  conf_tabs.add_tab(conf_tab_recipe, conf_tab_recipe_content)
  conf_tabs.add_tab(conf_tab_modules, conf_tab_modules_content)
  conf_tabs.add_tab(conf_tab_settings, conf_tab_settings_content)

  --
  -- results container
  --

  local results_frame = win_ct_f.add({
    type = "frame",
    style = "inside_shallow_frame",
  })
  results_frame.style.width = 350
  results_frame.style.height = 600
  local results_flow = results_frame.add({
    type = "flow",
    direction = "vertical",
  })
  local results_subheader_frame = results_flow.add({
    type = "frame",
    style = "subheader_frame",
  })
  results_subheader_frame.add({
    type = "label",
    style = "subheader_caption_label",
    caption = { "gui.mcalc-results-subheader-label" },
  })
  add_horizontal_pusher(results_subheader_frame)
  local results_scroll_pane = results_flow.add({
    type = "scroll-pane",
    direction = "vertical",
    vertical_scroll_policy = "auto",
  })

  return window
end


--- @param player LuaPlayer
--- @param visible boolean | nil Set true to show the gui, false to hide the
--- gui, nil to toggle the gui visiblity
function gui.set_visible(player, visible)
  local window = gui.get(player)
  if window then
    if visible ~= nil then
      window.visible = visible
    else
      window.visible = not window.visible
    end
  else
    -- do not use not visible because nil is possible
    if visible == false then
      return
    end
    gui.build(player)
    window = gui.get(player)
    window.visible = true
  end
  -- optimize this part of the thing
  -- it's a double check
  if window and window.visible then
    window.bring_to_front()
  end
end

--- Updates the GUI visually based on its current internal state
--- @param player LuaPlayer
function gui.update(player)
  -- pass
end

function gui.register_events()
  script.on_event(defines_events.on_gui_click, function(event)
    -- for regular buttons
  end)

  script.on_event(defines_events.on_gui_elem_changed, function(event)
    -- for elem buttons
  end)

  script.on_event(defines_events.on_gui_checked_state_changed, function(event)
    -- for radio buttons
  end)

  script.on_event(defines_events.on_gui_selection_state_changed, function(event)
    -- for dropdowns
  end)

  script.on_event(defines_events.on_gui_value_changed, function(event)
    -- for sliders
  end)

  script.on_event(defines_events.on_gui_text_changed, function(event)
    -- for textboxes
  end)

  script.on_event(defines_events.on_gui_confirmed, function(event)
    -- for text field confirmations
  end)
end

return gui
