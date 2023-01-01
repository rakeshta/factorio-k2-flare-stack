--
--  entity.lua
--  factorio-k2-flare-stack
--
--  Created by Rakesh Ayyaswami on 02 Jan 2023.
--

local sounds = require("__base__/prototypes/entity/sounds")
local graphics_path = k2_flare_stack_path .. "graphics/flare-stack/"
local sounds_path = k2_flare_stack_path .. "sounds/"

data:extend({
  {
    type = "furnace",
    name = "kr-fluid-burner",
    icon = graphics_path .. "flare-stack-icon.png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = { "placeable-neutral", "placeable-player", "player-creation" },
    minable = { mining_time = 0.5, result = "kr-fluid-burner" },
    max_health = 250,
    corpse = "medium-remnants",
    dying_explosion = "medium-explosion",
    resistances = {
      { type = "physical", percent = 50 },
      { type = "fire", percent = 95 },
    },
    fluid_boxes = {
      {
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        pipe_picture = pipe_patch,
        base_area = 5,
        base_level = -1,
        pipe_connections = { { type = "input", position = { 0.5, 1.5 } } },
      },
      off_when_no_fluid_recipe = false,
    },
    collision_box = { { -0.9, -0.9 }, { 0.9, 0.9 } },
    selection_box = { { -1, -1 }, { 1, 1 } },
    animation = {
      north = {
        layers = {
          {
            filename = graphics_path .. "flare-stack-n.png",
            width = 75,
            height = 150,
            frame_count = 1,
            shift = { 0, -1 },
            hr_version = {
              filename = graphics_path .. "hr-flare-stack-n.png",
              width = 150,
              height = 300,
              scale = 0.5,
              frame_count = 1,
              shift = { 0, -1 },
            },
          },
          {
            filename = graphics_path .. "flare-stack-sh.png",
            priority = "high",
            scale = scale,
            width = 129,
            height = 47,
            shift = { 1.1, 0.25 },
            frame_count = 1,
            draw_as_shadow = true,
            hr_version = {
              filename = graphics_path .. "hr-flare-stack-sh.png",
              priority = "high",
              width = 258,
              height = 94,
              shift = { 1.1, 0.25 },
              frame_count = 1,
              draw_as_shadow = true,
              scale = 0.5,
            },
          },
        },
      },
      east = {
        layers = {
          {
            filename = graphics_path .. "flare-stack-e.png",
            width = 75,
            height = 150,
            frame_count = 1,
            shift = { 0, -1 },
            hr_version = {
              filename = graphics_path .. "hr-flare-stack-e.png",
              width = 150,
              height = 300,
              scale = 0.5,
              frame_count = 1,
              shift = { 0, -1 },
            },
          },
          {
            filename = graphics_path .. "flare-stack-sh.png",
            priority = "high",
            scale = scale,
            width = 129,
            height = 47,
            shift = { 1.1, 0.25 },
            frame_count = 1,
            draw_as_shadow = true,
            hr_version = {
              filename = graphics_path .. "hr-flare-stack-sh.png",
              priority = "high",
              width = 258,
              height = 94,
              shift = { 1.1, 0.25 },
              frame_count = 1,
              draw_as_shadow = true,
              scale = 0.5,
            },
          },
        },
      },
      south = {
        layers = {
          {
            filename = graphics_path .. "flare-stack-s.png",
            width = 75,
            height = 150,
            frame_count = 1,
            --line_length = 6,
            shift = { 0, -1 },
            --animation_speed = 0.5
            hr_version = {
              filename = graphics_path .. "hr-flare-stack-s.png",
              width = 150,
              height = 300,
              scale = 0.5,
              frame_count = 1,
              shift = { 0, -1 },
            },
          },
          {
            filename = graphics_path .. "flare-stack-sh.png",
            priority = "high",
            scale = scale,
            width = 129,
            height = 47,
            shift = { 1.1, 0.25 },
            frame_count = 1,
            draw_as_shadow = true,
            hr_version = {
              filename = graphics_path .. "hr-flare-stack-sh.png",
              priority = "high",
              width = 258,
              height = 94,
              shift = { 1.1, 0.25 },
              frame_count = 1,
              draw_as_shadow = true,
              scale = 0.5,
            },
          },
        },
      },
      west = {
        layers = {
          {
            filename = graphics_path .. "flare-stack-w.png",
            width = 75,
            height = 150,
            frame_count = 1,
            shift = { 0, -1 },
            hr_version = {
              filename = graphics_path .. "hr-flare-stack-w.png",
              width = 150,
              height = 300,
              scale = 0.5,
              frame_count = 1,
              shift = { 0, -1 },
            },
          },
          {
            filename = graphics_path .. "flare-stack-sh.png",
            priority = "high",
            scale = scale,
            width = 129,
            height = 47,
            shift = { 1.1, 0.25 },
            frame_count = 1,
            draw_as_shadow = true,
            hr_version = {
              filename = graphics_path .. "hr-flare-stack-sh.png",
              priority = "high",
              width = 258,
              height = 94,
              shift = { 1.1, 0.25 },
              frame_count = 1,
              draw_as_shadow = true,
              scale = 0.5,
            },
          },
        },
      },
    },
    working_visualisations = {
      {
        apply_recipe_tint = "quaternary",
        fadeout = true,
        animation = {
          filename = graphics_path .. "flare-stack-fire.png",
          line_length = 10,
          width = 40,
          height = 81,
          frame_count = 60,
          animation_speed = 0.75,
          scale = 0.50,
          shift = { 0, -3.25 },
        },
      },
      {
        light = {
          intensity = 0.75,
          size = 25,
          shift = { 0, 0 },
          color = { r = 1, g = 0.95, b = 0.75 },
        },
      },
    },
    crafting_categories = { "fuel-burning" },
    vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound = {
      sound = {
        filename = sounds_path .. "flare-stack.ogg",
        volume = 1.7,
      },
      idle_sound = {
        filename = "__base__/sound/idle1.ogg",
        volume = 1,
      },
      apparent_volume = 1,
    },
    crafting_speed = 1.0,
    energy_source = {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute = 5,
    },

    water_reflection = {
      pictures = {
        filename = graphics_path .. "flare-stack-reflection.png",
        priority = "extra-high",
        width = 20,
        height = 30,
        shift = util.by_pixel(0, 40),
        variation_count = 1,
        scale = 5,
      },
      rotate = false,
      orientation_to_variation = false,
    },

    energy_usage = "0.1MW",
    source_inventory_size = 1,
    result_inventory_size = 1,
    module_specification = { module_slots = 1 },
    allowed_effects = { "speed", "pollution", "consumption" },
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
  },
})
