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
    private Gtk.ScrolledWindow drive_list_parent;
    private Marquer.Utils.DriveManager drive_manager;
    private Marquer.Utils.VolatileDataStore volatile_data_store;
    public signal void user_selection_completed ();
        
    public RightSelectDrive () {
        Object ();        
    }
    
    construct {               
        //Initialize Elements
        volatile_data_store = Marquer.Utils.VolatileDataStore.instance;
         
        drive_list = new Gtk.ListBox ();
        drive_list.selection_mode = Gtk.SelectionMode.BROWSE;
        drive_list.hexpand = true;
        drive_list.vexpand = true;
        
        drive_list.row_activated.connect((selected_disk_row) => {
            volatile_data_store.drive_information = volatile_data_store.connected_drives.get_object_member ("drive-data-" + (selected_disk_row.get_index () + 1).to_string ()).get_string_member ("drive-unix-id"); //Adding 1 as List Length starts from 'one'
            volatile_data_store.drive_name = volatile_data_store.connected_drives.get_object_member ("drive-data-" + (selected_disk_row.get_index () + 1).to_string ()).get_string_member ("drive-name");
            
            user_selection_completed ();
        });      
        
        drive_list_parent = new Gtk.ScrolledWindow (null, null);
        drive_list_parent.hscrollbar_policy = Gtk.PolicyType.NEVER;
        drive_list_parent.max_content_height = 650;
        drive_list_parent.add (drive_list);
        
        drive_frame = new Gtk.Frame ("");
        drive_frame.hexpand = true;
        drive_frame.vexpand = true;        
        drive_frame.margin = 10; 
        drive_frame.get_label_widget ().destroy (); // Remove the Label, Workaround as null label not possible
        drive_frame.add (drive_list_parent);        
        
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
    
    private void update_drive_list (List<Drive> connected_drives) {
        drive_list.foreach((existing_drive) => { existing_drive.destroy (); });
        connected_drives.foreach((drive) => {            
            var drive_label = drive.get_identifier (DRIVE_IDENTIFIER_KIND_UNIX_DEVICE);
            var drive_icon = drive.get_icon();
            
            if (drive_label.has_prefix ("/dev/mmc")) {
                drive_icon = new ThemedIcon ("media-flash");
            }
                                                    
            drive_list.insert(new Marquer.Widgets.DriveListRowItem (drive.get_name (), drive_label, drive.is_removable (), drive_icon), -1);
            
            var drive_data = new Json.Object ();
            drive_data.set_string_member ("drive-name", drive.get_name ());
            drive_data.set_string_member ("drive-unix-id", drive_label);
            
            volatile_data_store.connected_drives.set_object_member ("drive-data-" + drive_list.get_children ().length ().to_string (), drive_data);            
        });
    }

}
