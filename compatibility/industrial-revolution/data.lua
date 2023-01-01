--
--  data.lua
--  factorio-k2-flare-stack
--
--  Created by Rakesh Ayyaswami on 02 Jan 2023.
--

local flare_stack_util = require(k2_flare_stack_public_lib .. "flare-stack-util")

if mods["IndustrialRevolution"] then
  flare_stack_util.addBurnFluidEmissionsMultiplier("glass-molten", 10.0)
  flare_stack_util.addBurnFluidEmissionsMultiplier("copper-molten", 10.0)
  flare_stack_util.addBurnFluidEmissionsMultiplier("tin-molten", 10.0)
  flare_stack_util.addBurnFluidEmissionsMultiplier("bronze-molten", 10.0)
  flare_stack_util.addBurnFluidEmissionsMultiplier("iron-molten", 10.0)
  flare_stack_util.addBurnFluidEmissionsMultiplier("gold-molten", 10.0)
  flare_stack_util.addBurnFluidEmissionsMultiplier("nickel-molten", 10.0)
  flare_stack_util.addBurnFluidEmissionsMultiplier("lead-molten", 10.0)
  flare_stack_util.addBurnFluidEmissionsMultiplier("steel-molten", 10.0)
  flare_stack_util.addBurnFluidEmissionsMultiplier("invar-molten", 10.0)
  flare_stack_util.addBurnFluidEmissionsMultiplier("cupronickel-molten", 10.0)
  flare_stack_util.addBurnFluidEmissionsMultiplier("chromium-molten", 10.0)
  flare_stack_util.addBurnFluidEmissionsMultiplier("tellurium-molten", 10.0)
  flare_stack_util.addBurnFluidEmissionsMultiplier("stainless-molten", 10.0)
  flare_stack_util.addBurnFluidEmissionsMultiplier("sulphur-gas", 10.0)
end
