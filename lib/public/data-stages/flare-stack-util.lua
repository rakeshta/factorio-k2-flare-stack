--
--  flare-stack-util.lua
--  factorio-k2-flare-stack
--
--  Created by Rakesh Ayyaswami on 01 Jan 2023.
--

local matrix = require("__k2-flare-stack__/lib/private/data-stages/matrix")

local burn_recipe_background_path = k2_flare_stack_path ..
    "graphics/burn-recipes-background/"

-- -- -- FLUID BURNER UTIL
-- Notes: in fluid burner for don't handle a fluid must be blacklisted

if not flare_stack.flare_stack_util then
  flare_stack.flare_stack_util = {}
  -- CONSTANTS
  flare_stack.flare_stack_util.CORNER_PATH = burn_recipe_background_path .. "burn-recipe-corner.png"
  flare_stack.flare_stack_util.CORNER_PATH_MASK = burn_recipe_background_path .. "burn-recipe-corner-mask.png"
  flare_stack.flare_stack_util.ICON_SIZE = 64
  flare_stack.flare_stack_util.SCALE = 0.34
end

-- Blacklisted fluids in burn recipes (singleton table)
if not flare_stack.flare_stack_util.blacklist then
  flare_stack.flare_stack_util.blacklist = {
    -- example: ["fluid-name"] = true,
  }
end

-- Products of burn recipes (singleton table)
if not flare_stack.flare_stack_util.fluid_products then
  flare_stack.flare_stack_util.fluid_products = {
    -- example: ["fluid-name"] = { { type = "item", name = "stone", amount = 1, probability = 0.30 } },
  }
end

-- Emissions of burn recipes (singleton table)
if not flare_stack.flare_stack_util.fluid_emissions_multiplier then
  flare_stack.flare_stack_util.fluid_emissions_multiplier = {
    ["crude-oil"] = 9.0,
    ["heavy-oil"] = 4.0,
    ["light-oil"] = 3.0,
    ["petroleum-gas"] = 2.0,
    ["lubricant"] = 4.0,
    ["steam"] = 0.0,
    ["water"] = 0.0,
  }
end

-- -- -- PUBLIC
-- Notes:
--[[
  This functions must be called in data phase,
  Krastorio generate all burn recipes in data update phase,
  if someone want add post data update phase burn modifications,
  must be regenerate the specific recipes.
]]
--
--------

--[[
  With this funcion, could be blacklisted in Krastorio a fluid for not be
  burn it in Krastorio fluid burner.
]]
--
-- @fluid_name, name of fluid to blacklist
function flare_stack.flare_stack_util.blacklistFluid(fluid_name)
  flare_stack.flare_stack_util.blacklist[fluid_name] = true
end

--[[
  With this funcion, is possible assign a product/products generated from
  burn a specific fluid in Krastorio fluid burner.

  The given table can be composed from one or more products
  must be defined with the standard form of Factorio inventory item:
  table :
  {
    {item_name, amount} or {type="item" item_name=_item_name, amount=_amount},
    ...
  }
  The product/products can't be another fluid! But could have a probability.

  Description of burn recipes suppose that products is composed only by one product
]]
--
-- @fluid_name, name of fluid that create the product
-- @products, the products table for this fluid
function flare_stack.flare_stack_util.addBurnFluidProduct(fluid_name, products)
  if products and #products > 0 then
    flare_stack.flare_stack_util.fluid_products[fluid_name] = products
  end
end

function flare_stack.flare_stack_util.setBurnFluidProduct(fluid_name, products)
  flare_stack.flare_stack_util.addBurnFluidProduct(fluid_name, products)
end

--[[
  With this funcion, is possible assign a emissions_multiplier generated from
  burn a specific fluid in Krastorio fluid burner.

  Can also be used to change exising values.
]]
--
function flare_stack.flare_stack_util.addBurnFluidEmissionsMultiplier(fluid_name, emissions_multiplier)
  if fluid_name and emissions_multiplier then
    flare_stack.flare_stack_util.fluid_emissions_multiplier[fluid_name] = emissions_multiplier
  end
end

function flare_stack.flare_stack_util.setBurnFluidEmissionsMultiplier(fluid_name, emissions_multiplier)
  flare_stack.flare_stack_util.addBurnFluidEmissionsMultiplier(fluid_name, emissions_multiplier)
end

--[[
  Create a burn fluid recipe of one fluid, with some conditions:
  - if fluid exist
  - if fluid is not blacklist
  - will automatically add sub product if present in fluid_burner_util.fluid_products
    added in fluid_burner_util.addBurnFluidProduct(fluid_name, product)
  - if the burn recipe already exist, will be overwritten
]]
--
function flare_stack.flare_stack_util.generateBurnFluidsRecipe(fluid_name)
  if data.raw.fluid[fluid_name] then
    local tech = flare_stack.helpers.findTechnologyThatUnlocksRecipe("kr-fluid-burner")
    local tech_name = tech and tech.name or nil
    local accepted = false
    if not flare_stack.flare_stack_util.blacklist[fluid_name] and not data.raw.fluid[fluid_name].hidden then
      accepted = true
    end -- blacklist

    if tech_name and accepted then
      local fluid = data.raw.fluid[fluid_name]
      local recipe = {
        type = "recipe",
        name = "kr-burn-" .. fluid.name,
        localised_name = { "recipe-name.kr-burn", fluid.localised_name or { "fluid-name." .. fluid.name } },
        localised_description = {
          "recipe-description.kr-burn",
          fluid.localised_name or { "fluid-name." .. fluid.name },
        },
        category = "fuel-burning",
        icons = {
          {
            icon = flare_stack.flare_stack_util.CORNER_PATH,
            icon_size = flare_stack.flare_stack_util.ICON_SIZE,
          },
          {
            icon = flare_stack.flare_stack_util.CORNER_PATH_MASK,
            icon_size = flare_stack.flare_stack_util.ICON_SIZE,
            tint = flare_stack.flare_stack_util.setTransparency(table.deepcopy(fluid.base_color), 0.9),
          },
        },
        crafting_machine_tint = {
          primary = fluid.base_color,
          secondary = flare_stack.flare_stack_util.setTransparency(table.deepcopy(fluid.base_color), 0.35),
          tertiary = flare_stack.flare_stack_util.setTransparency(table.deepcopy(fluid.flow_color), 0.5),
          quaternary = flare_stack.flare_stack_util.setTransparency(table.deepcopy(fluid.flow_color), 0.75),
        },
        energy_required = 2,
        enabled = false,
        hidden = true,
        hide_from_player_crafting = true,
        always_show_products = false,
        show_amount_in_title = false,
        ingredients = {
          { type = "fluid", name = fluid.name, amount = 100 },
        },
        results = {
          { type = "item", name = "kr-void", amount = 0 },
        },
        subgroup = "kr-void",
        order = fluid.order,
      }

      -- complete icon overlay
      flare_stack.helpers.addOverlayIconsToRecipe(
        recipe,
        flare_stack.helpers.prototypeIconsForOverlay(fluid),
        flare_stack.flare_stack_util.ICON_SIZE,
        flare_stack.flare_stack_util.SCALE
      )

      -- if have a residue, insert in product and changed description
      if flare_stack.flare_stack_util.fluid_products[fluid.name] then
        recipe.results = flare_stack.flare_stack_util.fluid_products[fluid.name]
        recipe.always_show_products = true
        recipe.localised_description = {
          "recipe-description.kr-burn-with-residue",
          { "fluid-name." .. fluid.name },
          { "item-name." .. flare_stack.helpers.itemName(flare_stack.flare_stack_util.fluid_products[fluid.name][1]) },
        }
      end

      -- if have a special emissions multiplier
      if flare_stack.flare_stack_util.fluid_emissions_multiplier[fluid.name] then
        recipe.emissions_multiplier = flare_stack.flare_stack_util.fluid_emissions_multiplier[fluid.name]
      end

      data:extend({ recipe })
      flare_stack.helpers.addUnlockRecipeToTechnology(tech_name, recipe.name)
    end
  end
end

-- For fade the fluid corner colors, used in flame quaternary colors definition
function flare_stack.flare_stack_util.setTransparency(colour, alpha)
  colour.a = alpha
  return colour
end

-- See https://en.wikipedia.org/wiki/Color_balance#Scaling_monitor_R,_G,_and_B
function flare_stack.flare_stack_util.scalingColorMonitor(fixer, colour)
  local fixer_matrix = matrix({ { fixer.r, 0, 0 }, { 0, fixer.g, 0 }, { 0, 0, fixer.b } })
  local colour_matrix = matrix({ { colour.r }, { colour.g }, { colour.b } })

  local result_matrix = fixer_matrix * colour_matrix

  return { r = result_matrix[1][1], g = result_matrix[2][1], b = result_matrix[3][1] }
end

-- -- -- KRASTORIO ONLY (Use it if you know what you are doing)

-- Generate all recipes
function flare_stack.flare_stack_util.generateBurnFluidsRecipes()
  for _, fluid in pairs(data.raw.fluid) do
    flare_stack.flare_stack_util.generateBurnFluidsRecipe(fluid.name)
  end
end

return flare_stack.flare_stack_util
