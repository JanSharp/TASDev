
local function get_mod_setting_value(player_spec, setting_name)
  return settings.get_player_settings(player_spec)[setting_name].value
end

local function set_mod_setting_value(player_spec, setting_name, value)
  settings.get_player_settings(player_spec)[setting_name] = {value = value}
end

local function try_get_position(str)
  local func = load("return " .. str, nil, "t", {})
  if not func then return false end
  local success, position = pcall(func)
  if not success then return false end
  if type(position) ~= "table" then return false end
  local x, y = position.x, position.y
  if type(x) == "number" and type(y) == "number" then
    return true, {x = x, y = y}
  end
  x, y = position[1], position[2]
  if type(x) == "number" and type(y) == "number" then
    return true, {x = x, y = y}
  end
  return false
end

local function position_to_str(position)
  return "{" .. (position.x or position[1]) .. ", " .. (position.y or position[2]) .. "}"
end

local function get_spawn_location(player_spec)
  local value = get_mod_setting_value(player_spec, "TASDev-spawn-here-location")
  local success, location = try_get_position(value)
  if not success then
    location = {x = 0, y = 0}
    set_mod_setting_value(
      player_spec,
      "TASDev-spawn-here-location",
      position_to_str(location))
  end
  return location
end

return {
  get_mod_setting_value = get_mod_setting_value,
  set_mod_setting_value = set_mod_setting_value,
  try_get_position = try_get_position,
  position_to_str = position_to_str,
  get_spawn_location = get_spawn_location,
}
