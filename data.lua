--
--  data.lua
--  factorio-k2-flare-stack
--
--  Created by Rakesh Ayyaswami on 01 Jan 2023.
--

k2_flare_stack_path = "__k2-flare-stack__/"
k2_flare_stack_public_lib = k2_flare_stack_path .. "lib/public/data-stages/"

-- enable compatibility with k2-steel-pipes if mod is present
k2_steel_pipes_compat = mods["k2-steel-pipes"]

flare_stack = {};

require(k2_flare_stack_path .. "lib/private/data-stages/log")
require(k2_flare_stack_path .. "lib/private/data-stages/helpers")

require("prototypes.pipe-patch.index")
require("prototypes.flare-stack.index")
require("prototypes.void.index")
require("prototypes.categories")
require("prototypes.technology")
