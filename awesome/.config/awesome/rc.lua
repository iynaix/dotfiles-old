-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- Extra layouts
-- local bling = require("bling")
local OCS = require("OrderedClientStartup")
local tilewide = require("tilewide")
local fix_startup_id = require("config.fix_startup_id")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- awful spawn doesn't seem to spawn programs
local function spawn_on_tag(screen, tag, spawn_cmd, spawn_props)
    awful.screen.focus(screen)
    awful.screen.focused().tags[tag]:view_only()
    awful.spawn.with_shell(spawn_cmd, spawn_props)
end

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile.right,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    awful.layout.suit.floating,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- local tasklist_buttons = gears.table.join(
--                      awful.button({ }, 1, function (c)
--                                               if c == client.focus then
--                                                   c.minimized = true
--                                               else
--                                                   c:emit_signal(
--                                                       "request::activate",
--                                                       "tasklist",
--                                                       {raise = true}
--                                                   )
--                                               end
--                                           end),
--                      awful.button({ }, 3, function()
--                                               awful.menu.client_list({ theme = { width = 250 } })
--                                           end),
--                      awful.button({ }, 4, function ()
--                                               awful.client.focus.byidx(1)
--                                           end),
--                      awful.button({ }, 5, function ()
--                                               awful.client.focus.byidx(-1)
--                                           end))

awful.screen.connect_for_each_screen(function(s)
    print(s.index, s.geometry.width, s.geometry.height)

    -- Each screen has its own tag table.
    for i = 1, 9 do
        -- local use_single_master = s.geometry.width > s.geometry.height and s.geometry.width <= 1920

        local is_vertical = s.geometry.height > s.geometry.width
        local is_ultrawide = s.geometry.width > 3000

        -- bling.layout.equalarea,
        -- bling.layout.centered,

        awful.tag.add(tostring(i), {
            screen = s,
            -- master_count = use_single_master and 1 or 2,
            -- Vertical tile layout as default for vertical monitor
            -- layout = is_vertical and awful.layout.suit.tile.bottom or
            --     awful.layout.suit.tile.right,
            layout = is_vertical and tilewide.bottom or is_ultrawide and tilewide.right or awful.layout.suit.tile.right,
            column_count = (is_ultrawide or is_vertical) and 2 or 1,
        })
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a window style tasklist widget
    -- s.mytasklist = awful.widget.tasklist {
    --     screen  = s,
    --     filter  = awful.widget.tasklist.filter.currenttags,
    --     buttons = tasklist_buttons
    -- }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }

    -- s.tags[1]:view_only()
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
-- show menu, unused
-- awful.button({ }, 3, function () mymainmenu:toggle() end),
-- awful.button({}, 4, awful.tag.viewnext),
-- awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
-- Show help
    awful.key({ modkey, "Shift" }, "/", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),

    -- Focus on tags
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    -- awful.key({ modkey, }, "Escape", awful.tag.history.restore,
    --     { description = "go back", group = "tag" }),

    awful.key({ modkey, }, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    -- awful.key({ modkey,           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = "client"}),

    -- Master and column manipulation
    awful.key({ modkey, }, "m", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "m", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, }, "n", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Shift" }, "n", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),

    -- Swap layout
    awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),

    -- Focus Screen
    awful.key({ modkey, }, "Tab", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Shift" }, "Tab", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),

    -- Standard program

    -- TODO
    awful.key({ modkey, }, "y", function() spawn_on_tag(1, 3 - 1, terminal .. " --class ranger -e ranger ~/Downloads")
    end,
        { description = "testing opening of programs on screen and tag", group = "launcher" }),
    -- END TODO

    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }),

    awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),

    -- awful.key({ modkey, "Control" }, "n",
    --           function ()
    --               local c = awful.client.restore()
    --               -- Focus restored client
    --               if c then
    --                 c:emit_signal(
    --                     "request::activate", "key.unminimize", {raise = true}
    --                 )
    --               end
    --           end,
    --           {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey, "Shift" }, "Return", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }),

    awful.key({ modkey }, "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
        { description = "show the menubar", group = "launcher" })
)

clientkeys = gears.table.join(
    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, }, "BackSpace", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    -- go back to previous tag, i3 style
                    if #screen.selected_tags == 1 and screen.selected_tag == tag then
                        awful.tag.history.restore(screen)
                    else
                        tag:view_only()
                    end
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = {},
        properties = { border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            -- spawn new window in last position
            callback = awful.client.setslave,
        }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
            --   "DTA",  -- Firefox addon DownThemAll.
            --   "copyq",  -- Includes session name in class.
            --   "pinentry",
        },
        class = {
            --   "Arandr",
            --   "Blueman-manager",
            --   "Gpick",
            --   "Kruler",
            --   "MessageWin",  -- kalarm.
            --   "Sxiv",
            --   "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
            --   "Wpa_gui",
            --   "veromix",
            --   "xtightvncviewer"
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
            "Event Tester", -- xev.
        },
        role = {
            "AlarmWindow", -- Thunderbird's calendar.
            "ConfigManager", -- Thunderbird's about:config.
            "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
        }
    }, properties = { floating = true } },

    { rule_any = { type = { "normal", "dialog" }
    }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = 2 } },
    { rule = { instance = "ranger" },
        properties = { screen = 1, tag = "3", urgent = false } },
    { rule = { instance = "initialterm" },
        properties = { screen = 2, tag = "1", urgent = false } },
    { rule = { class = "Brave-browser" },
        properties = { screen = 1, tag = "1", urgent = false } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- TODO: detect laptop or dual / triple monitors
-- Add gaps
beautiful.useless_gap = 8
beautiful.border_width = 2
beautiful.border_normal = "#30302f"
beautiful.border_focus = "#4491ed"

-- TODO: Autostart
awful.spawn.with_shell("~/bin/wallpaper")
awful.spawn.with_shell("xrdb ~/.Xresources")
awful.spawn.with_shell("pgrep picom && pkill picom || picom -b")

local screen1 = screen[1]
local screen2 = screen[2]
local screen3 = screen[3]

--[[
-- web
awful.spawn.once("brave", {
    placement = awful.placement.left,
    screen = screen1,
    tag = 1,
})

awful.spawn.once("brave --incognito", {
    placement = awful.placement.right,
    screen = screen1,
    tag = 1,
})
--]]

-- file browsers
-- awful.spawn.once(terminal .. " --class ranger -e ranger ~/Downloads")

-- awful.spawn.once("nemo", {
--     screen = screen1,
--     tag = 4,
-- })

-- misc terminal
-- awful.spawn.once(terminal .. " --class initialterm")

-- chats
-- awful.spawn.once("firefox-developer-edition --class=ffchat https://discordapp.com/channels/@me https://web.whatsapp.com http://localhost:9091"
--     , {
--     screen = screen3,
--     tag = 1,
-- })

-- --downloads
-- awful.spawn.once(terminal, {
--     placement = awful.placement.right,
--     screen = screen3,
--     tag = 2,
-- })

-- awful.spawn.once(editor_cmd .. " ~/Desktop/yt.txt", {
--     placement = awful.placement.left,
--     screen = screen3,
--     tag = 2,
-- })

-- autostart, OrderedClientList adapted from:
-- https://reddit.com/r/awesomewm/comments/a1uccr/guide_autostart_script_for_spawning_clients_on/

-- popen not the best way to check if startup already happened...but good enough
-- until 4.3 comes out, and pgrep is quick enough to not block for periods of
-- time

-- local fd = io.popen("pgrep bash | wc -l")
-- local num_bash = tonumber(fd:read('*all'))
-- fd:close()
-- if (num_bash < 1) then

--USAGE: OCS:add_app(index, command, tag, screen, [geo={x,y,w,h}])
-- OCS:add_app("brave", screen1.tags[1], screen1)
-- OCS:add_app("brave --incognito", screen1.tags[1], screen1)

-- OCS:add_app(terminal .. " --class ranger -e ranger ~/Downloads", screen1.tags[3], screen1)
-- OCS:add_app("nemo", screen1.tags[4], screen1)

-- OCS:add_app(terminal .. " --class initialterm", screen2.tags[1], screen2)

OCS:add_app(
    "firefox-developer-edition --class=ffchat https://discordapp.com/channels/@me https://web.whatsapp.com http://localhost:9091"
    , 3, 1)

-- OCS:add_app(terminal, screen3.tags[2], screen3)
-- OCS:add_app(editor_cmd .. " ~/Desktop/yt.txt", screen3.tags[2], screen3)

-- starts spawning apps
OCS:begin_startup()
-- end
