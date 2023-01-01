--
--  log.lua
--  factorio-k2-flare-stack
--
--  Created by Rakesh Ayyaswami on 02 Jan 2023.
--

local inspect = require("inspect")

flare_stack.log = {}

function flare_stack.log.error(txt)
  flare_stack.log._("ERROR", txt)
end

function flare_stack.log._(level, txt)
  local base_level = 1
  if debug.getinfo(3) then
    base_level = 2
  end
  local out_file, out_function_name, out_line =
  debug.getinfo(base_level + 1).short_src,
      debug.getinfo(base_level + 1).name,
      debug.getinfo(base_level + 1).currentline
  local in_file, in_function_name, in_line =
  debug.getinfo(base_level).short_src, debug.getinfo(base_level).name, debug.getinfo(base_level).currentline

  log("k2-flare-stack|LogLevel:" .. level)
  if in_function_name then
    log("From k2-flare-stack->file:" .. in_file .. "->function:" .. in_function_name .. "->line:" .. in_line)
  else
    log("From k2-flare-stack->file:" .. in_file .. "->line:" .. in_line)
  end
  if out_function_name then
    log("Called in->file:" .. out_file .. "->function:" .. out_function_name .. "->line:" .. out_line)
  else
    log("Called in->file:" .. out_file .. "->line:" .. out_line)
  end
  log("Message: " .. inspect(txt))

  return true
end
