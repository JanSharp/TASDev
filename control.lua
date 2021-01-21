
local gui_handler = require("__JanSharpsGuiLibrary__.gui-handler")
local tasdev_util = require("tasdev-util")

require("position-gui")

local player_deleted_flag = 1

local function deregister_player(player_index)
  local inst = global.position_guis[player_index]
  -- if the event fires while the class is
  -- still being instantiated, inst will be nil
  if inst then
    inst:got_destroyed()
    global.position_guis[player_index] = nil
  else
    global.position_guis[player_index] = player_deleted_flag
  end
end

local function register_player(player)
  local inst = gui_handler.create(player.gui.screen, "position-gui", nil, player)
  if inst.elem.valid then -- could be deleted already
    local is_deleted = global.position_guis[player.index] == player_deleted_flag
    global.position_guis[player.index] = inst
    if is_deleted then
      deregister_player(player.index)
    else
    end
  end
end

local update_settings_handlers = {
  ["TASDev-spawn-here-location"] = function(player_index)
    local inst = global.position_guis[player_index]
    if inst then
      local location = tasdev_util.get_spawn_location(player_index)
      inst:set_location(location)
    end
  end,
  ["TASDev-position-list-row-count"] = function(player_index)
    local inst = global.position_guis[player_index]
    if inst then
      inst:set_row_count_from_setting()
    end
  end,
  ["TASDev-tb-width"] = function(player_index)
    local inst = global.position_guis[player_index]
    if inst then
      inst:set_tb_width_from_setting()
    end
  end,
  ["TASDev-decimal-limit"] = function(player_index)
    local inst = global.position_guis[player_index]
    if inst then
      inst:set_decimal_limit_from_setting()
    end
  end,
}



script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)
  register_player(player)
end)

script.on_event(defines.events.on_player_removed, function(event)
  deregister_player(event.player_index)
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  if event.setting_type == "runtime-per-user" then
    local update_settings_handler = update_settings_handlers[event.setting]
    if event.player_index then
      update_settings_handler(event.player_index)
    else
      for player_index in next, global.position_guis do
        update_settings_handler(player_index)
      end
    end
  end
end)

script.on_event("TASDev-add-positions", function(event)
  global.position_guis[event.player_index]:add_current_positions()
end)

script.on_init(function()
  global.position_guis = {}

  for _, player in pairs(game.players) do
    register_player(player)
  end
end)
