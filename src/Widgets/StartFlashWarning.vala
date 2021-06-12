/*
    Marquer
    Copyright (C) 2021  Atheesh Thirumalairajan

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
    
    Authored By: Atheesh Thirumalairajan <candiedoperation@icloud.com>
*/

public class Marquer.Widgets.StartFlashWarning : Gtk.Grid {
    public Gtk.Button warning_action_button;
        
    public StartFlashWarning (string title, string description, ThemedIcon gicon, string button_label) {
        Object ();
        
        //user_selection_completed (0);
        
        var warning_label = new Gtk.Label (title);
        warning_label.halign = Gtk.Align.START;
        warning_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
        
        var warning_description = new Gtk.Label (description);
        warning_description.halign = Gtk.Align.START;
        warning_description.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        
        var warning_grid = new Gtk.Grid ();
        warning_grid.attach (warning_label, 0, 0);
        warning_grid.attach (warning_description, 0, 1);
        
        var warning_logo = new Gtk.Image ();
        warning_logo.gicon = gicon;
        warning_logo.pixel_size = 48;
        
        warning_action_button = new Gtk.Button ();
        warning_action_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        warning_action_button.label = button_label;
        warning_action_button.halign = Gtk.Align.END;
        
        var insufficient_param_alert = new Gtk.Grid ();
        insufficient_param_alert.column_spacing = 10;
        insufficient_param_alert.row_spacing = 10;
        insufficient_param_alert.attach (warning_logo, 0, 0);
        insufficient_param_alert.attach (warning_grid, 1, 0);
        insufficient_param_alert.attach (warning_action_button, 1, 1);
        
        add (insufficient_param_alert);
        show_all ();                
    }
    
    construct {

    }
    
    public void purge () {
        this.destroy ();
    }
}
