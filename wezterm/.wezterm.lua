local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action
local io = require("io")
local os = require("os")
local brightness = 0.03

-- image setting
local home = os.getenv("HOME")
local background_folder = home .. "/dotfiles/bg"
local shortcuts_file = home .. "/dotfiles/wezterm/shortcuts.lua"

local function get_background_images(folder)
    local handle = io.popen('ls "' .. folder .. '"')
    if handle == nil then
        return {}
    end

    local files = handle:read("*a")
    handle:close()

    local images = {}
    for file in string.gmatch(files, "[^\n]+") do
        table.insert(images, file)
    end

    table.sort(images)
    return images
end

local function pick_next_background(folder, current_image)
    local images = get_background_images(folder)
    if #images == 0 then
        return nil
    end

    local current_name = current_image and current_image:match("([^/]+)$")
    for index, file in ipairs(images) do
        if file == current_name then
            local next_index = (index % #images) + 1
            return folder .. "/" .. images[next_index]
        end
    end

    return folder .. "/" .. images[1]
end

local function basename(path)
    if path == nil then
        return nil
    end

    return path:match("([^/\\]+)$")
end

local function load_shortcut_sections()
    local ok, sections = pcall(dofile, shortcuts_file)
    if ok then
        return sections
    end

    wezterm.log_error("Failed to load shortcuts file: " .. sections)
    return {}
end

local shortcut_sections = load_shortcut_sections()

local function pad_right(text, width)
    if #text >= width then
        return text .. "  "
    end

    return text .. string.rep(" ", width - #text)
end

local function build_shortcut_choices()
    local choices = {}

    for _, section in ipairs(shortcut_sections) do
        for _, entry in ipairs(section.entries) do
            local label = pad_right(section.name, 12) .. pad_right(entry.keys, 24) .. entry.desc
            table.insert(choices, {
                id = label,
                label = label,
            })
        end
    end

    return choices
end

local function show_shortcut_palette(window, pane)
    window:perform_action(
        act.InputSelector({
            title = "Shortcut Help: WezTerm / tmux / Neovim",
            choices = build_shortcut_choices(),
            fuzzy = true,
            action = wezterm.action_callback(function(_, _, _, _)
            end),
        }),
        pane
    )
end

local function should_passthrough_ctrl_h(pane)
    local process_name = basename(pane:get_foreground_process_name())
    if process_name == "tmux" or process_name == "nvim" or process_name == "vim" then
        return true
    end

    return pane:is_alt_screen_active()
end

config.window_background_image_hsb = {
    brightness = brightness,
    hue = 1.0,
    saturation = 0.8,
}

-- default background
local bg_image = home .. "/dotfiles/bg/default.png"

config.window_background_image = bg_image

config.window_background_opacity = 1
config.macos_window_background_blur = 85
config.window_padding = {
    left = 4,
    right = 4,
    top = 0,
    bottom = 0,
}

config.color_scheme = "Tokyo Night"
config.font = wezterm.font("Inconsolata Nerd Font Mono", { weight = "Medium", stretch = "Expanded" })
config.font_size = 14

config.enable_tab_bar = false

config.window_frame = {
    border_left_width = "0.18cell",
    border_right_width = "0.18cell",
    border_bottom_height = "0.08cell",
    border_top_height = "0.08cell",
    border_left_color = "black",
    border_right_color = "black",
    border_bottom_color = "black",
    border_top_color = "black",
}

-- keys
config.keys = {
    {
        key = "h",
        mods = "CTRL",
        action = wezterm.action_callback(function(window, pane)
            if should_passthrough_ctrl_h(pane) then
                window:perform_action(
                    act.SendKey({
                        key = "h",
                        mods = "CTRL",
                    }),
                    pane
                )
                return
            end

            show_shortcut_palette(window, pane)
        end),
    },
    {
        key = "h",
        mods = "CTRL|SHIFT",
        action = wezterm.action_callback(function(window, pane)
            show_shortcut_palette(window, pane)
        end),
    },
    {
        key = "b",
        mods = "CTRL|SHIFT",
        action = wezterm.action_callback(function(window)
            bg_image = pick_next_background(background_folder, bg_image)
            if bg_image then
                window:set_config_overrides({
                    window_background_image = bg_image,
                })
                wezterm.log_info("New bg:" .. bg_image)
            else
                wezterm.log_error("Could not find bg image")
            end
        end),
    },
    {
        key = "L",
        mods = "CTRL|SHIFT",
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
    {
        key = ">",
        mods = "CTRL|SHIFT",
        action = wezterm.action_callback(function(window)
            brightness = math.min(brightness + 0.01, 1.0)
            window:set_config_overrides({
                window_background_image_hsb = {
                    brightness = brightness,
                    hue = 1.0,
                    saturation = 0.8,
                },
                window_background_image = bg_image,
            })
        end),
    },
    {
        key = "<",
        mods = "CTRL|SHIFT",
        action = wezterm.action_callback(function(window)
            brightness = math.max(brightness - 0.01, 0.01)
            window:set_config_overrides({
                window_background_image_hsb = {
                    brightness = brightness,
                    hue = 1.0,
                    saturation = 0.8,
                },
                window_background_image = bg_image,
            })
        end),
    },
  {
    key = 'n',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.ToggleFullScreen,
  },
    { key = 'q', mods = 'SHIFT|CTRL', action = wezterm.action.QuitApplication },

}

-- others
config.default_cursor_style = "BlinkingUnderline"
config.cursor_thickness = 1
config.max_fps = 60
return config
