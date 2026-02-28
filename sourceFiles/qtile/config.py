# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile import bar, layout, widget, qtile, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from qtile_extras import widget
from qtile_extras.widget.decorations import PowerLineDecoration

import os
import subprocess

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([home])


mod = "mod4"
terminal = "alacritty"

keys = [
    # Switch between windows
    Key([mod], "j", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "k", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "i", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "j", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "i", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "j", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "k", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "i", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    #Keybinds personalizados
    Key([mod], "q", lazy.spawn("rofi -show drun -show-icons -theme rofiPersonalizado", "Ejecuta Rofi para aplicaciones")),
]

groups = [Group(f"{i+1}", label="󰏃") for i in range(5)]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

bordeIzquierdo = {
    "decorations": [
        PowerLineDecoration(path="rounded_left", size=10)
    ]
}

bordeDerecho = {
    "decorations": [
        PowerLineDecoration(path="rounded_right", size=10)
    ]
}

bordeCentral = {
    "decorations": [
        PowerLineDecoration(path="forward_slash", size=10)
    ]
}

bordeCentral2 = {
    "decorations": [
        PowerLineDecoration(path="back_slash", size=10)
    ]
}

bordeApagado = {
    "decorations": [
        PowerLineDecoration(path="rounded_right", size=5)
    ]
}

barra = {
    "fondo": "#2e3440",
    "grupoSeleccionado": "#cae1fc",
    "grupoInactivo": "#526680",
    "grupoActivo": "#5398ed",
}



# Configuración de  estilo  de los layouts
def init_layout_theme():
    return  {"margin":3,
            "border_width":2,
            "border_focus": barra["grupoActivo"],
            "border_normal": "#4c566a",
            }

layout_theme = init_layout_theme()

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    **layout_theme,
)

layouts = [
    layout.Max(),
    layout.MonadTall(**layout_theme),
    layout.Bsp(**layout_theme),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=2,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper='/home/lea/Imágenes/Fondos de Escritorio/minimalista-azul.jpg',
        wallpaper_mode='fill',
        top=bar.Bar(
            [
                widget.TextBox(
                    text="  ",
                    background="#000000",
                    fontsize=16,
                    mouse_callbacks={'Button1': lambda:qtile.cmd_spawn('rofi -show drun -show-icons -theme rofiPersonalizado'),},
                    **bordeCentral2
                    ),

                widget.GroupBox(
                    padding=2,
                    highlight_method="block",
                    active=barra["grupoActivo"],
                    inactive=barra["grupoInactivo"],
                    block_highlight_text_color=barra["grupoSeleccionado"],
                    background=barra["fondo"],
                    this_current_screen_border=barra["fondo"],
                    fontsize=16,
                    **bordeCentral2
                    ),

                widget.CurrentLayoutIcon(
                    background=barra["grupoInactivo"],
                    use_mask=True,
                    foreground=barra["grupoSeleccionado"],
                    padding=1,
                    scale=0.7255,
                    **bordeIzquierdo,
                ),

                widget.Spacer(
                    length=5,
                    **bordeCentral2,
                ),

                #widget.GlobalMenu(
                #    padding=10,
                #    font="Fira Code Medium",
                #    background=barra["fondo"],
                #    fontsize=12,
                #    **bordeCentral2,
                #),

                #widget.Spacer(
                #    length=3,
                ##),

                widget.WindowName(
                    padding=0,
                    font="Fira Code Medium",
                    fontsize=12,
                    **bordeDerecho,
                    ),
               
                widget.WidgetBox(
                    background=barra["fondo"],
                    text_closed="",
                    text_open="",
                    fontsize=15,
                    foreground=barra["grupoSeleccionado"],
                    widgets=[
                        widget.StatusNotifier(
                            background=barra["fondo"],
                            **bordeCentral,
                        ),

                        widget.TextBox(
                            text="|",
                            background=barra["fondo"],
                            font="Fira Code Bold",
                            fontsize=15,
                        ),

                        widget.PulseVolume(
                            fmt="󰕾 {}",
                            background=barra["fondo"],
                            font="Fira Code Bold",
                            fontsize=13.5,
                        ),

                        widget.TextBox(
                            text="|",
                            background=barra["fondo"],
                            font="Fira Code Bold",
                            fontsize=15,
                        ),

                        widget.WiFiIcon(
                            expanded_timeout=2,
                            background=barra["fondo"],
                            padding=6,
                            **bordeCentral,
                        ),
                    ],
                    **bordeCentral,
                ),

                widget.Clock(
                    format="󰃰 %d-%m-%y [%H:%M]",
                    font= "Fira Code Bold", 
                    background=barra["grupoInactivo"],
                    fontsize=13.5,
                    **bordeCentral,
                    ),     
                
                widget.UPowerWidget(
                    margin=3,
                    background=barra["fondo"],
                    font="Fira Code Bold",
                    ),
                
                widget.TextBox(
                    text=" ",
                    background=barra["fondo"],
                    padding=-4,
                    **bordeIzquierdo,
                ),
                
                widget.Spacer(length=5, **bordeApagado),

                widget.WidgetBox(
                    background="#bf616a",
                    text_closed="󰐦",
                    text_open="󰜴 ",
                    fontsize=18,
                    padding=5,
                    widgets=[
                        widget.TextBox(
                            text=" ",
                            padding=3,
                            fontsize=15,
                            mouse_callbacks={'Button1': lambda:qtile.cmd_spawn('shutdown -h now'),},
                            background="#bf616a",
                        ),

                        widget.TextBox(
                            text=" ",
                            padding=3,
                            fontsize=15,
                            mouse_callbacks={'Button1': lambda:qtile.cmd_spawn('shutdown -r now'),},
                            background="#bf616a",
                        ),

                        widget.TextBox(
                            text="⭘ ",
                            padding=3,
                            fontsize=15,
                            mouse_callbacks={'Button1': lazy.shutdown(),},
                            background="#bf616a",
                        ),
                    ],
                ),


            ],
            25,
            background="#00000000",
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
