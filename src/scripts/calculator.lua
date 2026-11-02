-- SPDX-FileCopyrightText: 2026 eightcraters <eightcraters@hotmail.com>
-- SPDX-License-Identifier: Apache-2.0

local floor = math.floor
local sqrt = math.sqrt

--- @param x number[]
--- @return number total
local function sum(x)
  local total = 0
  for _, v in ipairs(x) do
    total = total + v
  end
  return total
end

--- @generic T
--- @param original T[]
--- @return T[] copy
local function copy_list(original)
  local copy = {}
  for i, v in ipairs(original) do
    copy[i] = v
  end
  return copy
end

-- class definitions

--- @class CalculationSettings
--- @field pad_distribution_efficiency number
--- @field pad_module_value number
--- @field module_values number[]
--- @field distribution_efficiencies number[]
--- @field max_beacon_count number
--- @field tolerance number Maximum (inclusive) tolerable absolute difference
--- between calculation and the target value

--- Represents one beacon and its modules
--- @class BeaconData
--- @field distribution_efficiency number
--- @field modules number[]
local BeaconData = {}

-- module export

local calculator = {}

--- @param total number The total DE-multiplied percentage
--- @param n number Number of beacons
--- @param target number The target value
--- @return number raw_residual
function calculator.get_raw_residual_from_total(total, n, target)
  local factor = sqrt(n) / n
  return (target / factor) - total
end


-- Raw residual refers to the residual boost that represents the sum of the
-- remaining modules multiplied by their beacons' respective distribution
-- efficiencies. This is NOT the number that the module percentages should add
-- up to. You should divide the raw residual by a distribution efficiency first
-- to obtain the actual module value required.

-- If a base effect from the machine or its internal modules exists, add it directly
-- to target.

--- @param beacons BeaconData[] An array of all the beacons. Include empty
--- beacons in which modules will be inserted
--- @param target number The target percentage
--- @return number raw_residual
function calculator.get_raw_residual_from_beacons(beacons, target)
  local n = #beacons
  -- Don't use a sum function in outer because it needs to be floored first
  local total = 0
  for _, beacon in ipairs(beacons) do
    local de = beacon.distribution_efficiency
    total = total + floor(de * sum(beacon.modules))
  end
  return calculator.get_raw_residual_from_total(total, n, target)
end


--- @param numbers number[] A list of numbers which can be used to reach target
--- @param target number The target value
--- @param max_count number | nil The maximum amount of addends allowed (inclusive).
--- Leave nil for no limit.
--- @return boolean possible Whether or not it is possible to use [numbers] to
--- sum up to this value
function calculator.get_addend_possible(numbers, target, max_count)
  local possible = false

  local function backtrack(remaining, start_index, current_combination)
    if max_count and #current_combination > max_count then
      return
    end
    if remaining == 0 then
      possible = true
      return
    elseif remaining < 0 or possible then
      return
    end
    for i = start_index, #numbers do
      table.insert(current_combination, numbers[i])
      backtrack(remaining - numbers[i], i, current_combination)
      table.remove(current_combination)
    end
  end

  backtrack(target, 1, {})
  return possible
end


--- This is the primary function for evaluating all possible combinations of
--- modules which can reach a specified target percentage.
--- @param numbers number[] A list of numbers which can be used to reach target
--- @param target number The target value
--- @param max_count number | nil The maximum amount of addends allowed (inclusive).
--- Leave nil for no limit.
--- @return number[][] possible_combinations A list of all the possible
--- combinations of numbers which can be summed up to equal target
function calculator.get_all_valid_addend_combinations(numbers, target, max_count)
  local result = {}

  local function backtrack(remaining, start_index, current_combination)
    if max_count ~= nil and #current_combination > max_count then
      return
    end
    if remaining == 0 then
      table.insert(result, copy_list(current_combination))
      return
    elseif remaining < 0 then
      return
    end

    -- put any other filters here

    for i = start_index, #numbers do
      table.insert(current_combination, numbers[i])
      backtrack(remaining - numbers[i], i, current_combination)
      table.remove(current_combination)
    end
  end

  backtrack(target, 1, {})
  return result
end

return calculator
