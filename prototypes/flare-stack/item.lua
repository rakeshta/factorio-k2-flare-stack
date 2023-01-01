--
--  item.lua
--  factorio-k2-flare-stack
--
--  Created by Rakesh Ayyaswami on 02 Jan 2023.
--

local graphics_path = k2_flare_stack_path .. "graphics/flare-stack/"

data:extend({
  {
    type = "item",
    name = "kr-fluid-burner",
    icon = graphics_path .. "flare-stack-icon.png",
    icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "production-machine",
    order = "e-d1[fluid-burner]",
    place_result = "kr-fluid-burner",
    stack_size = 50,
  },
})
