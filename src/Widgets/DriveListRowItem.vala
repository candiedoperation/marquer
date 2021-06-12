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

public class Marquer.Widgets.DriveListRowItem : Gtk.ListBoxRow {
    public DriveListRowItem (string drive_name, string drive_info, bool is_removable_drive, Icon drive_icon) {
        Object ();
        
        var drive_info_label = new Gtk.Label (drive_info);
        drive_info_label.hexpand = true;
        drive_info_label.halign = Gtk.Align.START;
        
        var drive_title_label = new Gtk.Label (drive_name);
        drive_title_label.hexpand = true;
        drive_title_label.halign = Gtk.Align.START;
        drive_title_label.ellipsize = Pango.EllipsizeMode.MIDDLE;
        
        unowned var drive_title_context = drive_title_label.get_style_context ();        
        drive_title_context.add_class (Granite.STYLE_CLASS_H2_LABEL);        
        
        if (is_removable_drive == false) {
            drive_title_label.label += " (Non Removable Drive)";
            drive_title_context.add_class (Gtk.STYLE_CLASS_WARNING); 
        }
        
        var grid_row = new Gtk.Grid ();
        grid_row.attach (drive_title_label, 0, 0);
        grid_row.attach (drive_info_label, 0, 1);
        
        var grid_main = new Gtk.Grid ();
        grid_main.margin = 5;
        grid_main.column_spacing = 7;
        grid_main.hexpand = true;        
        grid_main.attach (new Gtk.Image.from_gicon (drive_icon, Gtk.IconSize.LARGE_TOOLBAR), 0, 0);
        grid_main.attach (grid_row, 1, 0);
        
        add (grid_main);
        show_all ();              
    }
    
    construct {
                         
    }
}
