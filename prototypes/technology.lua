--
--  technology.lua
--  factorio-k2-flare-stack
--
--  Created by Rakesh Ayyaswami on 02 Jan 2023.
--

local graphics_path = k2_flare_stack_path .. "graphics/technology/"

local prerequisite_fluid_tech = k2_steel_pipes_compat and "kr-steel-fluid-handling" or "fluid-handling"

data:extend({
  {
    type = "technology",
    name = "kr-fluid-excess-handling",
    mod = "k2-flare-stack",
    icon = graphics_path .. "fluid-burner.png",
    icon_size = 256,
    icon_mipmaps = 4,
    effects = {
      {
        type = "unlock-recipe",
        recipe = "kr-fluid-burner",
      },
    },
    prerequisites = { prerequisite_fluid_tech, "electronics" },
    unit = {
      count = 150,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
      },
      time = 45,
    },
  },
})
