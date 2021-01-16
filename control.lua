
local gui_handler = require("__JanSharpsGuiLibrary__.gui-handler")

require("position-gui")

script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)

  local inst = gui_handler.create(player.gui.screen, "position-gui", nil, player)
  global.position_guis[event.player_index] = inst
end)

script.on_event("TASDev-add-positions", function(event)
  global.position_guis[event.player_index]:add_current_positions()
end)

script.on_init(function()
  global.position_guis = {}
end)
