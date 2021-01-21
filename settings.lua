
local consts = require("consts")

data:extend{
  {
    name = "TASDev-spawn-here-location",
    setting_type = "runtime-per-user",
    type = "string-setting",
    default_value = "{0, 0}",
    allow_blank = true,
  },
  {
    name = "TASDev-position-list-row-count",
    setting_type = "runtime-per-user",
    type = "int-setting",
    default_value = consts.default_row_count,
    minimum_value = consts.min_row_count,
    maximum_value = consts.max_row_count,
  },
  {
    name = "TASDev-tb-width",
    setting_type = "runtime-per-user",
    type = "int-setting",
    default_value = consts.default_tb_width,
    minimum_value = consts.min_tb_width,
    maximum_value = consts.max_tb_width,
  },
  {
    name = "TASDev-decimal-limit",
    setting_type = "runtime-per-user",
    type = "int-setting",
    default_value = consts.default_decimal_limit,
    minimum_value = consts.min_decimal_limit,
    maximum_value = consts.max_decimal_limit,
  },
}
