/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2018-2024 Ryo Nakano <ryonakaknock3@gmail.com>
 */

public class StyleManager : Object {
    public const string COLOR_SCHEME_DEFAULT = "default";
    public const string COLOR_SCHEME_FORCE_LIGHT = "force-light";
    public const string COLOR_SCHEME_FORCE_DARK = "force-dark";

    public string color_scheme { get; set; }

    public static unowned StyleManager get_default () {
        if (instance == null) {
            instance = new StyleManager ();
        }

        return instance;
    }
    private static StyleManager instance = null;

    private Gtk.Settings gtk_settings;
    private Granite.Settings granite_settings;

    private StyleManager () {
    }

    construct {
        gtk_settings = Gtk.Settings.get_default ();
        granite_settings = Granite.Settings.get_default ();

        notify["color-scheme"].connect (color_scheme_changed_cb);
        granite_settings.notify["prefers-color-scheme"].connect (color_scheme_changed_cb);
    }

    private void color_scheme_changed_cb () {
        bool is_prefer_dark;

        switch (color_scheme) {
            case COLOR_SCHEME_FORCE_LIGHT:
                is_prefer_dark = false;
                break;
            case COLOR_SCHEME_FORCE_DARK:
                is_prefer_dark = true;
                break;
            case COLOR_SCHEME_DEFAULT:
                is_prefer_dark = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
                break;
            default:
                warning ("Invalid color_scheme: %s", color_scheme);
                return;
        }

        gtk_settings.gtk_application_prefer_dark_theme = is_prefer_dark;
    }
}
