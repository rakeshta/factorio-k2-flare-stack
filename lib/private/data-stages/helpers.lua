--
--  helpers.lua
--  factorio-k2-flare-stack
--
--  Created by Rakesh Ayyaswami on 02 Jan 2023.
--

flare_stack.helpers = {}

--- Creates a deep copy of a table without copying factorio objects
-- internal table refs are also deepcopy. The resulting table should
-- @usage local copy = flare_stack.helpers.tableFullCopy[data.raw.["stone-furnace"]["stone-furnace"]]
-- -- returns a deepcopy of the stone furnace entity with no internal table references.
-- @tparam table object the table to copy
-- @treturn table a copy of the table
function flare_stack.helpers.tableFullCopy(object)
  local lookup_table = {}
  local function _copy(this_object)
    if type(this_object) ~= "table" then
      return this_object
    elseif this_object.__self then
      return this_object
    elseif lookup_table[this_object] then
      return _copy(lookup_table[this_object])
    end
    local new_table = {}
    lookup_table[this_object] = new_table
    for index, value in pairs(this_object) do
      new_table[_copy(index)] = _copy(value)
    end
    return setmetatable(new_table, getmetatable(this_object))
  end

  return _copy(object)
end

-- List of all item types
flare_stack.helpers.item_types = {
  "ammo",
  "armor",
  "capsule",
  "fluid", -- But why
  "gun",
  "item",
  "mining-tool",
  "module",
  "tool",
  "item-with-entity-data",
  "repair-tool",
}


-- Finds the item with the given name.
function flare_stack.helpers.findItem(item_name)
  if type(item_name) == "string" then
    for _, type_name in pairs(flare_stack.helpers.item_types) do
      local item = data.raw[type_name][item_name]
      if item then
        return item
      end
    end
  end
  return nil
end

-- Returns the name of the item
function flare_stack.helpers.itemName(item)
  return item.name or item[1]
end

-- Tests whether the given recipe exists
function flare_stack.helpers.recipeExists(recipe_name)
  return flare_stack.helpers.recipeFromName(recipe_name) ~= nil
end

-- Return a recipe given its name if it exists
function flare_stack.helpers.recipeFromName(recipe_name)
  return data.raw.recipe[recipe_name]
end

-- Returns the technology given its name or the technology itself.
function flare_stack.helpers.technologyFromName(technology_name)
  if type(technology_name) == "table" then
    return technology_name
  end
  if type(technology_name) == "string" then
    return data.raw.technology[technology_name]
  end
end

-- Finds the technology that unlocks the named recipe.
function flare_stack.helpers.findTechnologyThatUnlocksRecipe(recipe_name)
  for name, technology in pairs(data.raw.technology) do
    if (technology.enabled == true or technology.enabled == nil) and technology.effects then
      for _, effect in pairs(technology.effects) do
        if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
          return technology
        end
      end
    end
  end
  return nil
end

-- Returns the effects of the named technology
function flare_stack.helpers.technologyEffects(technology_name)
  local technology = flare_stack.helpers.technologyFromName(technology_name)
  if technology and next(technology) ~= nil then
    if technology.effects then
      return technology.effects
    end
  end
  return {}
end

function flare_stack.helpers.addUnlockRecipeToTechnology(technology_name, recipe_name)
  return flare_stack.helpers.addEffectToTechnology(technology_name, { type = "unlock-recipe", recipe = recipe_name })
end

-- Adds one or more effects to the tiven technology if it doesn't already exist.
function flare_stack.helpers.addEffectToTechnology(technology_name, new_effect)
  local effects = flare_stack.helpers.technologyEffects(technology_name)
  if next(effects) ~= nil then
    -- looking if new_effect if not present
    local found = false
    for _, effect in pairs(effects) do
      if effect.type == new_effect.type then
        if effect.type == "gun-speed" then
          if effect.ammo_category == new_effect.ammo_category and effect.modifier == new_effect.modifier then
            found = true
            break
          end
        elseif effect.type == "ammo-damage" then
          if effect.ammo_category == new_effect.ammo_category and effect.modifier == new_effect.modifier then
            found = true
            break
          end
        elseif effect.type == "give-item" then
          if effect.item == new_effect.item and effect.count == new_effect.count then
            found = true
            break
          end
        elseif effect.type == "turret-attack" then
          if effect.turret_id == new_effect.turret_id and effect.modifier == new_effect.modifier then
            found = true
            break
          end
        elseif effect.type == "unlock-recipe" then
          if effect.recipe == new_effect.recipe then
            found = true
            break
          end
        elseif effect.type == "nothing" then
          if effect.effect_description == new_effect.effect_description then
            found = true
            break
          end
        else
          if effect.modifier == new_effect.modifier then
            found = true
            break
          end
        end
      end
    end
    -- add it if not present
    if not found then
      if new_effect.type == "unlock-recipe" then
        if flare_stack.helpers.recipeExists(new_effect.recipe) then
          table.insert(effects, new_effect)
          return true
        else
          flare_stack.log.error(
            string.format(
              "Can't add to %s, the effect of unlock recipe %s, because recipe %s don't exist!",
              technology_name,
              new_effect.recipe,
              new_effect.recipe
            )
          )
        end
      else
        table.insert(effects, new_effect)
        return true
      end
    end
  else
    local technology = flare_stack.helpers.technologyFromName(technology_name)
    if technology and next(technology) ~= nil then
      technology.effects = { new_effect }
    end
  end
  return false
end

--- Standardize and return the prototype's `icons` table.
--- @param proto table
--- @return table
function flare_stack.helpers.prototypeIconsForOverlay(proto)
  local icons_table = {}
  if proto.icons then
    -- copy all icons from the source item to the returned table,
    -- but populate the icon_size in each icon; we want the icon size defined in each icon for future overlay scaling
    for _, original_icon in ipairs(proto.icons) do
      -- create a copy of the icon with the appropriately found size
      local new_icon = flare_stack.helpers.tableFullCopy(original_icon)
      -- per https://wiki.factorio.com/Types/IconSpecification, icon_size should be defined in one of two places
      new_icon.icon_size = (proto.icon_size or original_icon.icon_size or 32)
      table.insert(icons_table, new_icon)
    end
  else
    if not proto.icon and proto.type == "recipe" then
      ---@diagnostic disable-next-line: param-type-mismatch
      return flare_stack.helpers.prototypeIconsForOverlay(flare_stack.helpers.findItem(proto.name))
    elseif not proto.icon and proto.type ~= "recipe" then
      return {}
    end
    -- single icon, simple insert
    table.insert(icons_table, {
      icon = proto.icon,
      icon_size = proto.icon_size,
    })
  end
  return icons_table
end

function flare_stack.helpers.addOverlayIconsToRecipe(item_or_recipe, icons_to_add, icon_size, scale, shift)
  local scale = (scale or 1)
  local shift = (shift or { 0, 0 })
  local icon_size = (icon_size or item_or_recipe.icon_size or 64)
  if type(icons_to_add) == "string" then
    icons_to_add = { {
      icon = icons_to_add,
      icon_size = icon_size,
    } }
  end

  if not item_or_recipe.icons then
    -- normalize to icon specification option 1, with icon size defined in each layer
    item_or_recipe.icons = flare_stack.helpers.prototypeIconsForOverlay(item_or_recipe)
    -- clean up after ourselves
    item_or_recipe.icon = nil
    item_or_recipe.icon_size = nil
  end

  -- add the requested additional icons
  for _, icon_to_add in ipairs(icons_to_add) do
    local overlay_icon = flare_stack.helpers.tableFullCopy(icon_to_add)
    -- preserve the overlay icon's scale and include the argument requested scale, accounting for differing icon sizes
    overlay_icon.scale = scale * (icon_size / overlay_icon.icon_size) * (overlay_icon.scale or 1)

    if overlay_icon.shift then
      -- if the overlay icon had shift already, preserve it and add the argument requested shift
      overlay_icon.shift = { overlay_icon.shift[1] + shift[1], overlay_icon.shift[2] + shift[2] }
    else
      -- if the overlay icon had no shift, use the argument requested shift
      overlay_icon.shift = shift
    end

    table.insert(item_or_recipe.icons, overlay_icon)
  end
end
