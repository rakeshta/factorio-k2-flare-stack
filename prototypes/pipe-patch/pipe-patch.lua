--
--  pipe-patch.lua
--  factorio-k2-flare-stack
--
--  Created by Rakesh Ayyaswami on 02 Jan 2023.
--

local graphics_path = k2_flare_stack_path .. "graphics/"

local empty_sprite = {
  filename = graphics_path .. "empty.png",
  priority = "high",
  width = 1,
  height = 1,
  scale = 0.5,
  shift = { 0, 0 },
}

kr_pipe_path = {
  north = empty_sprite,
  east = empty_sprite,
  south = {
    filename = graphics_path .. "pipe-patch/pipe-patch.png",
    priority = "high",
    width = 28,
    height = 25,
    shift = { 0.01, -0.58 },
    hr_version = {
      filename = graphics_path .. "pipe-patch/hr-pipe-patch.png",
      priority = "high",
      width = 55,
      height = 50,
      scale = 0.5,
      shift = { 0.01, -0.58 },
    },
  },
  west = empty_sprite,
}
