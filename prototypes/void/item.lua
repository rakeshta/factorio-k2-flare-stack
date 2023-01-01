--
--  item.lua
--  factorio-k2-flare-stack
--
--  Created by Rakesh Ayyaswami on 02 Jan 2023.
--

local graphics_path = k2_flare_stack_path .. "graphics/void/"

data:extend({
  {
    type = "item",
    name = "kr-void",
    icon = graphics_path .. "void.png",
    flags = { "hidden" },
    icon_size = 64,
    icon_mipmaps = 4,
    order = "zzz[kr-void]",
    stack_size = 999,
  },
})
