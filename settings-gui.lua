
local gui_handler = require("__JanSharpsGuiLibrary__.gui-handler")
require("__JanSharpsGuiLibrary__.basic-classes")
local consts = require("consts")
local tasdev_util = require("tasdev-util")

local settings_gui = {class_name = "settings-gui"}

function settings_gui.create(position_gui)
  return {
    type = "frame",
    caption = "TAS Dev Settings",
    direction = "vertical",

    elem_mods = {
      auto_center = true,
    },
    style_mods = {
      width = 400,
    },

    children = {
      {class_name = "flow", {
        direction = "horizontal",
        children = {
          {class_name = "label", {caption = "row count: "}},
          {class_name = "label", name = "row_count_lb", parent_pass_count = 1, {
            caption = tostring(position_gui.row_count),
          }},
        },
      }},
      {class_name = "slider", name = "row_count_sl", {
        minimum_value = consts.min_row_count,
        maximum_value = consts.max_row_count,
        value = position_gui.row_count,
        value_step = 1,
        style = "notched_slider",
        style_mods = {
          horizontally_stretchable = true,
        },
      }},

      {class_name = "flow", {
        direction = "horizontal",
        children = {
          {class_name = "label", {caption = "text box width: "}},
          {class_name = "label", name = "tb_width_lb", parent_pass_count = 1, {
            caption = tostring(position_gui.tb_width),
          }},
        },
      }},
      {class_name = "slider", name = "tb_width_sl", {
        minimum_value = consts.min_tb_width,
        maximum_value = consts.max_tb_width,
        value = position_gui.tb_width,
        value_step = 1,
        style_mods = {
          horizontally_stretchable = true,
        },
      }},

      {class_name = "flow", {
        direction = "horizontal",
        children = {
          {class_name = "label", {caption = "decimal limit: "}},
          {class_name = "label", name = "decimal_limit_lb", parent_pass_count = 1, {
            caption = tostring(position_gui.decimal_limit),
          }},
        },
      }},
      {class_name = "slider", name = "decimal_limit_sl", {
        minimum_value = consts.min_decimal_limit,
        maximum_value = consts.max_decimal_limit,
        value = position_gui.decimal_limit,
        value_step = 1,
        style = "notched_slider",
        style_mods = {
          horizontally_stretchable = true,
        },
      }},

      {class_name = "flow", {
        direction = "horizontal",
        style = "dialog_buttons_horizontal_flow",
        children = {
          {class_name = "button", name = "back_btn", parent_pass_count = 1, {
            caption = "Back",
            style = "back_button",
          }},
          {class_name = "empty-widget", name = "filler", parent_pass_count = 1, {
            style = "draggable_space",
            style_mods = {
              horizontally_stretchable = true,
              vertically_stretchable = true,
            },
          }},
          {class_name = "button", name = "confirm_btn", parent_pass_count = 1, {
            caption = "Confirm",
            style = "confirm_button",
          }},
        },
      }},
    },
  },
  {
    player = position_gui.player,
    position_gui = position_gui,
    prev_settings = {
      row_count = position_gui.row_count,
      tb_width = position_gui.tb_width,
      decimal_limit = position_gui.decimal_limit,
    },
  }
end

-- events

function settings_gui:on_create()
  self.filler.elem.drag_target = self.elem
end

function settings_gui:on_click_back_btn(back_btn, event)
  self:close()
end

function settings_gui:on_click_confirm_btn(confirm_btn, event)
  self:confirm()
end

function settings_gui:on_value_changed_row_count_sl(row_count_sl, event)
  local value = row_count_sl.elem.slider_value
  self.row_count_lb.elem.caption = tostring(value)
  self.position_gui:set_row_count(value, true)
end

function settings_gui:on_value_changed_tb_width_sl(tb_width_sl, event)
  local value = tb_width_sl.elem.slider_value
  self.tb_width_lb.elem.caption = tostring(value)
  self.position_gui:set_tb_width(value, true)
end

function settings_gui:on_value_changed_decimal_limit_sl(decimal_limit_sl, event)
  local value = decimal_limit_sl.elem.slider_value
  self.decimal_limit_lb.elem.caption = tostring(value)
  self.position_gui:set_decimal_limit(value, true)
end

-- class functions

function settings_gui:set_row_count(row_count)
  self.row_count_lb.elem.caption = tostring(row_count)
  self.row_count_sl.elem.slider_value = row_count
  self.prev_settings.row_count = row_count
end

function settings_gui:set_tb_width(tb_width)
  self.tb_width_lb.elem.caption = tostring(tb_width)
  self.tb_width_sl.elem.slider_value = tb_width
  self.prev_settings.tb_width = tb_width
end

function settings_gui:set_decimal_limit(decimal_limit)
  self.decimal_limit_lb.elem.caption = tostring(decimal_limit)
  self.decimal_limit_sl.elem.slider_value = decimal_limit
  self.prev_settings.decimal_limit = decimal_limit
end

function settings_gui:close()
  local current = self.position_gui
  local prev = self.prev_settings

  if current.row_count ~= prev.row_count then
    self.position_gui:set_row_count(prev.row_count, true)
  end
  if current.tb_width ~= prev.tb_width then
    self.position_gui:set_tb_width(prev.tb_width, true)
  end
  if current.decimal_limit ~= prev.decimal_limit then
    self.position_gui:set_decimal_limit(prev.decimal_limit, true)
  end
  self.position_gui:close_settings()
end

function settings_gui:confirm()
  local current = self.position_gui
  local prev = self.prev_settings

  if current.row_count ~= prev.row_count then
    tasdev_util.set_mod_setting_value(
      self.player,
      "TASDev-position-list-row-count",
      current.row_count)
  end
  if current.tb_width ~= prev.tb_width then
    tasdev_util.set_mod_setting_value(
      self.player,
      "TASDev-tb-width",
      current.tb_width)
  end
  if current.decimal_limit ~= prev.decimal_limit then
    tasdev_util.set_mod_setting_value(
      self.player,
      "TASDev-decimal-limit",
      current.decimal_limit)
  end
  self.position_gui:close_settings()
end

gui_handler.register_class(settings_gui)
