--
--  recipe.lua
--  factorio-k2-flare-stack
--
--  Created by Rakesh Ayyaswami on 02 Jan 2023.
--

data:extend({
  {
    type = "recipe",
    name = "kr-fluid-burner",
    energy_required = 5,
    enabled = false,
    ingredients = {
      { "steel-plate", 10 },
      { "iron-plate", 20 },
      { "electronic-circuit", 3 },
    },
    result = "kr-fluid-burner",
  },
})
