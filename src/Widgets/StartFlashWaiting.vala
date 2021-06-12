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

public class Marquer.Widgets.StartFlashWaiting : Gtk.Grid {
    public StartFlashWaiting (string title) {
        Object ();
        
        var wait_spinner = new Gtk.Spinner ();
        wait_spinner.height_request = 48;
        wait_spinner.width_request = 48;
        wait_spinner.start ();
        
        var wait_label = new Gtk.Label (title);
        wait_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
        
        var wait_grid = new Gtk.Grid ();
        wait_grid.hexpand = true;
        wait_grid.vexpand = true;
        wait_grid.column_spacing = 10;
        wait_grid.halign = Gtk.Align.CENTER;
        wait_grid.valign = Gtk.Align.CENTER;
        wait_grid.attach (wait_spinner, 0, 0);
        wait_grid.attach (wait_label, 1, 0);        
        
        add (wait_grid);
        show_all ();                
    }
    
    construct {

    }
    
    public void purge () {
        this.destroy ();
    }
}
