
require("settings-gui")
local gui_handler = require("__JanSharpsGuiLibrary__.gui-handler")
require("__JanSharpsGuiLibrary__.basic-classes")
local tasdev_util = require("tasdev-util")
local consts = require("consts")

local font_size = 14 -- font prototype size


local position_gui = {class_name = "position-gui"}

function position_gui.create(player)
  return {
    type = "frame",
    caption = "TAS Dev Positions",
    direction = "vertical",

    children = {
      {class_name = "table", {
        column_count = 2,
        children = {
          {class_name = "label", {caption = "selected"}},
          {class_name = "label", {caption = "player"}},
          {class_name = "text-box", name = "selected_pos_tb", parent_pass_count = 1},
          {class_name = "text-box", name = "player_pos_tb", parent_pass_count = 1},
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
          {class_name = "button", name = "settings_btn", parent_pass_count = 1, {
            caption = "settings",
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

    row_count = consts.default_row_count,
    tb_width = consts.default_tb_width,
    decimal_limit = consts.default_decimal_limit,
  }
end

-- events

function position_gui:on_elem_created()
  self:set_location(tasdev_util.get_spawn_location(self.player))
end

function position_gui:on_create()
  self:set_row_count_from_setting()
  self:set_tb_width_from_setting()
  self:set_decimal_limit_from_setting()
end

function position_gui:on_click_clear_btn(clear_btn, event)
  self:clear()
  self:draw_tb_text()
end

function position_gui:on_click_spawn_here_btn(spawn_here_btn, event)
  tasdev_util.set_mod_setting_value(
    self.player,
    "TASDev-spawn-here-location",
    tasdev_util.position_to_str(self.elem.location))
end

function position_gui:on_click_settings_btn(settings_btn, event)
  self:open_settings()
end

-- local

local function add_to_list_with_limit(list, value)
  for i = consts.max_row_count, #list do
    list[i] = nil
  end
  table.insert(list, 1, value)
end

local function apply_decimal_limit(value, decimal_limit)
  local cutoff = 10 ^ (-decimal_limit)
  local to_trim = value % cutoff
  value = value - to_trim
  if to_trim >= cutoff / 2 then
    value = value + cutoff
  end
  if to_trim <= -cutoff / 2 then
    value = value - cutoff
  end
  return value
end

local function build_positions_string(positions, row_count, decimal_limit)
  local strings = {}
  for i = 1, math.min(#positions, row_count) do
    local position = positions[i]
    if position then
      strings[i] = "{"
        .. apply_decimal_limit(position.x, decimal_limit) .. ", "
        .. apply_decimal_limit(position.y, decimal_limit)
        .. "}"
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
  self:draw_tb_text()
end

function position_gui:clear()
  self.selected_positions = {}
  self.player_positions = {}
end

function position_gui:draw_tb_text()
  self.selected_pos_tb.elem.text = build_positions_string(
    self.selected_positions,
    self.row_count,
    self.decimal_limit)

  self.player_pos_tb.elem.text = build_positions_string(
    self.player_positions,
    self.row_count,
    self.decimal_limit)
end

function position_gui:set_location(location)
  self.elem.location = location
end

function position_gui:set_row_count_from_setting()
  self:set_row_count(tasdev_util.get_mod_setting_value(self.player, "TASDev-position-list-row-count"))
end

function position_gui:set_tb_width_from_setting()
  self:set_tb_width(tasdev_util.get_mod_setting_value(self.player, "TASDev-tb-width"))
end

function position_gui:set_decimal_limit_from_setting()
  self:set_decimal_limit(tasdev_util.get_mod_setting_value(self.player, "TASDev-decimal-limit"))
end

function position_gui:set_row_count(row_count, do_not_update_settings_gui)
  self.row_count = row_count
  self:draw_tb_text()
  local height = (font_size + 6) * row_count + 8
  self.selected_pos_tb.elem.style.height = height
  self.player_pos_tb.elem.style.height = height

  if not do_not_update_settings_gui then
    local settings_gui = self.settings_gui
    if settings_gui then
      settings_gui:set_row_count(row_count)
    end
  end
end

function position_gui:set_tb_width(tb_width, do_not_update_settings_gui)
  self.tb_width = tb_width
  self.selected_pos_tb.elem.style.width = tb_width
  self.player_pos_tb.elem.style.width = tb_width

  if not do_not_update_settings_gui then
    local settings_gui = self.settings_gui
    if settings_gui then
      settings_gui:set_tb_width(tb_width)
    end
  end
end

function position_gui:set_decimal_limit(decimal_limit, do_not_update_settings_gui)
  self.decimal_limit = decimal_limit
  self:draw_tb_text()

  if not do_not_update_settings_gui then
    local settings_gui = self.settings_gui
    if settings_gui then
      settings_gui:set_decimal_limit(decimal_limit)
    end
  end
end

function position_gui:open_settings()
  local settings_gui = self.settings_gui
  if settings_gui then
    settings_gui.elem.bring_to_front()
  else
    self.settings_gui = gui_handler.create(self.player.gui.screen, "settings-gui", nil, self)
  end
end

function position_gui:close_settings()
  local settings_gui = self.settings_gui
  if settings_gui then
    self.elem.bring_to_front()
    settings_gui:destroy()
    self.settings_gui = nil
  end
end

gui_handler.register_class(position_gui)
