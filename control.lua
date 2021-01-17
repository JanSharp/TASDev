
local gui_handler = require("__JanSharpsGuiLibrary__.gui-handler")

require("position-gui")

local function register_player(player)
  local inst = gui_handler.create(player.gui.screen, "position-gui", nil, player)
  global.position_guis[player.index] = inst
end

local function deregister_player(player_index)
  global.position_guis[player_index]:got_destroyed()
  global.position_guis[player_index] = nil
end

script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)
  register_player(player)
end)

script.on_event(defines.events.on_player_removed, function(event)
  deregister_player(event.player_index)
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
