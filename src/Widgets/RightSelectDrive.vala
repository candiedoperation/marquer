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

public class Marquer.Widgets.RightSelectDrive : Gtk.Grid {
    private Gtk.ListBox drive_list;
    private Gtk.Frame drive_frame;
    private Marquer.Utils.DriveManager drive_manager;
        
    public RightSelectDrive () {
        Object ();        
    }
    
    construct {        
        //Initialize Elements 
        drive_list = new Gtk.ListBox ();
        drive_list.hexpand = true;
        drive_list.vexpand = true;
        
        drive_frame = new Gtk.Frame ("");
        drive_frame.hexpand = true;
        drive_frame.vexpand = true;        
        drive_frame.margin = 10; 
        drive_frame.get_label_widget ().destroy (); // Remove the Label, Workaround as null label not possible
        drive_frame.add(drive_list);        
        
        var test_label = new Gtk.Label("Drive Name");
        test_label.hexpand = true;
        test_label.halign = Gtk.Align.START;
                
        var test_label_1 = new Gtk.Label ("16 GB - W12OEN");
        test_label_1.hexpand = true;
        test_label_1.halign = Gtk.Align.START;        
        
        var grid_row = new Gtk.Grid();
        grid_row.hexpand = true;
        grid_row.margin = 3;
        
        grid_row.attach(test_label, 0, 0);
        grid_row.attach(test_label_1, 0, 1);
        
        var listrow = new Gtk.ListBoxRow ();
        listrow.add(grid_row);
        
        drive_list.insert(listrow, 0);
        
        drive_manager = new Marquer.Utils.DriveManager ();
        drive_manager.drive_list_update.connect((signal_handler, drive_list) => { update_drive_list (drive_list); });
        drive_manager.get_connected_drives ();        
        
        this.vexpand = true;
        this.hexpand = true;
        this.row_spacing = 6;
                
        //Attach Elements to Grid
        attach (drive_frame, 0, 0);
        
        show_all();
    }
    
    private void update_drive_list (List<Drive> drive_list) {
        print("RECEIVED DRIVE LIST");
    }
}
