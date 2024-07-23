-- 加载颜色转换函数库
local colormath = require('user.colormath')

local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

local function rgb_to_hex(r, g, b)
    return string.format("#%02x%02x%02x", r, g, b)
end

local function adjust_saturation(color, amount)
    local r, g, b = hex_to_rgb(color)
    local hsv = colormath.rgb_to_hsv(r, g, b)
    hsv.s = hsv.s * amount
    local rgb = colormath.hsv_to_rgb(hsv.h, hsv.s, hsv.v)
    return rgb_to_hex(rgb.r, rgb.g, rgb.b)
end

local function desaturate_colors(amount)
    local highlights = vim.api.nvim_exec('highlight', true)
    for line in highlights:gmatch("[^\r\n]+") do
        local group, settings = line:match('([^%s]+)%s+(.*)')
        if group and settings then
            local fg = settings:match("guifg=(#[0-9a-fA-F]+)")
            local bg = settings:match("guibg=(#[0-9a-fA-F]+)")
            if fg then
                fg = adjust_saturation(fg, amount)
            end
            if bg then
                bg = adjust_saturation(bg, amount)
            end
            vim.cmd(string.format("highlight %s guifg=%s guibg=%s", group, fg or "NONE", bg or "NONE"))
        end
    end
end

-- 设置饱和度比例
-- desaturate_colors(0.98)
