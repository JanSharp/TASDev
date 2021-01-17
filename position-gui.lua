
local gui_handler = require("__JanSharpsGuiLibrary__.gui-handler")
require("__JanSharpsGuiLibrary__.basic-classes")
local tasdev_util = require("tasdev-util")
local consts = require("consts")

local font_size = 14 -- font prototype size


local position_gui = {class_name = "position-gui"}

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
              width = 220,
            },
          }},
          {class_name = "text-box", name = "player_pos_tb", parent_pass_count = 1, {
            style_mods = {
              width = 220,
            },
          }},
        },
      }},
      {class_name = "flow", {
        children = {
          {class_name = "button", name = "clear_btn", parent_pass_count = 1, {
            caption = "clear",
            style_mods = {
              width = 60,
            },
          }},
          {class_name = "button", name = "spawn_here_btn", parent_pass_count = 1, {
            caption = "spawn here",
            style_mods = {
              width = 100,
            },
          }},
        },
      }},
    },

    player = player,
    selected_positions = {},
    player_positions = {},
  }
end

-- events

function position_gui:on_elem_created()
  self:set_location(tasdev_util.get_spawn_location(self.player))
end

function position_gui:on_create()
  self:set_row_count_from_setting()
end

function position_gui:on_click_clear_btn(clear_btn, event)
  self:clear()
  self:draw()
end

function position_gui:on_click_spawn_here_btn(spawn_here_btn, event)
  tasdev_util.set_mod_setting_value(
    self.player,
    "TASDev-spawn-here-location",
    tasdev_util.position_to_str(self.elem.location))
end

-- local

local function add_to_list_with_limit(list, value)
  for i = consts.max_row_count, #list do
    list[i] = nil
  end
  table.insert(list, 1, value)
end

local function build_positions_string(positions, row_count)
  local strings = {}
  for i = 1, math.min(#positions, row_count) do
    local position = positions[i]
    if position then
      strings[i] = "{" .. position.x .. ", " .. position.y .. "}"
    else
      strings[i] = ""
    end
  end
  return table.concat(strings, "\n")
end

-- class functions

function position_gui:add_current_positions()
  local player = self.player
  local selected = player.selected

  add_to_list_with_limit(self.selected_positions, selected and selected.position or false)
  add_to_list_with_limit(self.player_positions, player.position)
  self:draw()
end

function position_gui:clear()
  self.selected_positions = {}
  self.player_positions = {}
end

function position_gui:draw()
  self.selected_pos_tb.elem.text = build_positions_string(self.selected_positions, self.row_count)
  self.player_pos_tb.elem.text = build_positions_string(self.player_positions, self.row_count)
end

function position_gui:set_location(location)
  self.elem.location = location
end

function position_gui:set_row_count_from_setting()
  self:set_row_count(tasdev_util.get_mod_setting_value(self.player, "TASDev-position-list-row-count"))
end

function position_gui:set_row_count(row_count)
  self.row_count = row_count
  self:draw()
  local height = (font_size + 6) * row_count + 8
  self.selected_pos_tb.elem.style.height = height
  self.player_pos_tb.elem.style.height = height
end

gui_handler.register_class(position_gui)
