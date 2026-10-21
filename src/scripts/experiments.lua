-- SPDX-FileCopyrightText: 2026 eightcraters <eightcraters@hotmail.com>
-- SPDX-License-Identifier: Apache-2.0

local defines_events = defines.events

--- Takes any crafting machine entity and a choose-elem-button GUI element, then
--- sets the recipe filter of the button to show only recipes which the entity
--- can craft.
--- @param entity LuaEntity A crafting machine whose recipes are to be
--- transferred as a filter to element
--- @param element LuaGuiElement A choose-elem-button element
--- @return boolean success Whether or not the button's filter was set
--- successfully
local function set_recipe_filters(entity, element)
  if not (entity and element) then
    return false
  end
  if element.type ~= "choose-elem-button" then
    return false
  end
  local crafting_categories = entity.prototype.crafting_categories
  -- otherwise implies there is atleast one category
  if not crafting_categories then
    return false
  end
  local elem_filters = {}
  for _, crafting_category in ipairs(crafting_categories) do
    table.insert(elem_filters, {
      filter = "category",
      category = crafting_category,
      mode = "or",
    })
  end
  element.elem_filters = elem_filters
  return true
end

--- @param entity LuaEntity
--- @return LuaEntity[] beacons
local function get_affecting_beacons(entity)
  return entity.get_beacons()
end

local function get_module_prototypes()
  local module_prototypes = prototypes.get_item_filtered({
    {
      filter = "type",
      type = "module"
    }
  })
  local quality_prototypes = prototypes.quality
  for module_name, module_prototype in pairs(module_prototypes) do
    for quality_name, quality_prototype in pairs(quality_prototypes) do

    end
  end
end

-- The multiplier added by each level of a quality level
-- Note that level is NOT the literal number tier of a quality.
-- We can't use get_module_effects since 2.0.7 does not have it
-- Might also wanna rename BOOST to something more descriptive
local BOOST = 0.3

--- @param module_prototype LuaItemPrototype
--- @param quality_prototype LuaQualityPrototype
--- @return any effects The quality-modified effects of the module prototype
local function get_quality_module_effect(module_prototype, quality_prototype)
  local result = {}
  local level = quality_prototype.level
  local multiplier = 1 + level * BOOST
  -- module_effects can be nil.
  for effect_name, value in pairs(module_prototype.module_effects) do
    result[effect_name] = value * multiplier
  end
  return result
end


--- @param entity LuaEntity The entity to check for module slots
--- @return number count The amount of module slots in this entity as an integer
local function get_module_slot_count(entity)
  local inventory = entity.get_module_inventory()
  if inventory then
    return #inventory
  else
    return 0
  end
end


--- Gets the base effect bonuses applied onto an entity's prototype
--- An example would be the Foundry's +50% productivity bonus
--- @param entity LuaEntity The entity to check for a base effect
--- @return Effect | nil effect The base effect applied on this entity by default
local function get_effect_receiver(entity)
  local effect_receiver = entity.prototype.effect_receiver
  if not effect_receiver then
    return
  end
  local base_effect = effect_receiver.base_effect
  return base_effect
end


local function on_player_selected_area(event)
  local player = game.players[event.player_index]
  if not event.item == "mcalc-selection-tool" then
    return
  end
  for _, entity in ipairs(event.entities) do
    -- filter out the machines that can be affected by beacons
  end
end

script.on_event(defines_events.on_player_selected_area, function(event)
  on_player_selected_area(event)
end)

script.on_event(defines_events.on_player_alt_selected_area, function(event)
  on_player_selected_area(event)
end)

script.on_event(defines_events.on_player_reverse_selected_area, function(event)
  on_player_selected_area(event)
end)

script.on_event(defines_events.on_player_alt_reverse_selected_area, function(event)
  on_player_selected_area(event)
end)
