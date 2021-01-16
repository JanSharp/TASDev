
local gui_handler = require("__JanSharpsGuiLibrary__.gui-handler")
require("__JanSharpsGuiLibrary__.basic-classes")

local position_gui = {class_name = "position-gui"}

local font_size = 14 -- TODO: read from prototype? can you do that?
local positions_limit = 10

local textbox_height = (font_size + 8) * positions_limit + 8

function position_gui.create(player)
  return {
    type = "frame",
    caption = "position gui",
    direction = "vertical",

    children = {
      {class_name = "table", {
        column_count = 2,
        children = {
          {class_name = "label", {caption = "selected"}},
          {class_name = "label", {caption = "player"}},
          {class_name = "text-box", name = "selected_pos_tb", parent_pass_count = 1, {
            style_mods = {
              height = textbox_height,
            },
          }},
          {class_name = "text-box", name = "player_pos_tb", parent_pass_count = 1, {
            style_mods = {
              height = textbox_height,
            },
          }},
        },
      }},
      {class_name = "button", name = "clear_btn", {
        caption = "clear",
      }},
    },

    player = player,
    selected_positions = {},
    player_positions = {},
  }
end

function position_gui:on_click_clear_btn(clear_btn, event)
  self:clear()
  self:draw()
end

local function add_to_list_with_limit(list, value, limit)
  for i = limit, #list do
    list[i] = nil
  end
  table.insert(list, 1, value)
end

local function build_positions_string(positions)
  local strings = {}
  for i = 1, #positions do
    local position = positions[i]
    if position then
      strings[i] = "{" .. position.x .. ", " .. position.y .. "}"
    else
      strings[i] = ""
    end
  end
  return table.concat(strings, "\n")
end

function position_gui:add_current_positions()
  local player = self.player
  local selected = player.selected

  add_to_list_with_limit(self.selected_positions, selected and selected.position or false, positions_limit)
  add_to_list_with_limit(self.player_positions, player.position, positions_limit)
  self:draw()
end

function position_gui:clear()
  self.selected_positions = {}
  self.player_positions = {}
end

function position_gui:draw()
  self.selected_pos_tb.elem.text = build_positions_string(self.selected_positions)
  self.player_pos_tb.elem.text = build_positions_string(self.player_positions)
end

gui_handler.register_class(position_gui)
