
local gui_hander = require("__JanSharpsGuiLibrary__.gui-handler")
require("__JanSharpsGuiLibrary__.basic-classes")
local consts = require("consts")
local tasdev_util = require("tasdev-util")

local settings_gui = {class_name = "settings-gui"}

function settings_gui.create(position_gui)
  return {
    type = "frame",
    caption = "settings",
    direction = "vertical",

    elem_mods = {
      auto_center = true,
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
        minimum_value = 1,
        maximum_value = consts.max_row_count,
        value = position_gui.row_count,
        value_step = 1,
      }},
      {class_name = "button", name = "close_btn", {
        caption = "close",
        style_mods = {
          width = 80,
        },
      }},
    },

    player = position_gui.player,
  },
  {
    position_gui = position_gui,
  }
end

-- events

function settings_gui:on_click_close_btn(close_btn, event)
  self:close()
end

function settings_gui:on_value_changed_row_count_sl(row_count_sl, event)
  local value = row_count_sl.elem.slider_value
  tasdev_util.set_mod_setting_value(self.player, "TASDev-position-list-row-count", value)
  self.row_count_lb.elem.caption = tostring(value)
  self.position_gui:set_row_count(value, true)
end

-- class functions

function settings_gui:set_row_count(row_count)
  self.row_count_lb.elem.caption = tostring(row_count)
  self.row_count_sl.slider_value = row_count
end

function settings_gui:close()
  self.position_gui:close_settings()
end

gui_hander.register_class(settings_gui)
