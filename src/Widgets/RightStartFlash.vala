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

public class Marquer.Widgets.RightStartFlash : Gtk.Grid {
    private Gtk.Spinner wait_spinner;
    private Gtk.Grid wait_grid; 
    private Gtk.Label wait_label;
    private Gtk.Grid insufficient_param_alert;
    private Gtk.Label warning_label;
    private Gtk.Label warning_description;
    private Gtk.Image warning_logo;
    private Gtk.Button warning_action_button;
    private Marquer.Utils.VolatileDataStore volatile_data_store;
    private Granite.MessageDialog confirmation_dialog;
    public signal void user_selection_completed (int goto_page);
          
    public RightStartFlash () {
        Object ();        
    }
    
    construct {
        volatile_data_store = Marquer.Utils.VolatileDataStore.instance;
        
        volatile_data_store.notify.connect ((signal_handler, signal_data) => {
            if (volatile_data_store.disk_information.length == 0) {
                show_disk_warning ();
            } else if (volatile_data_store.drive_information.length == 0) {
                show_drive_warning ();
            }  else {
                show_waiting_status ();
                
                Timeout.add (500, () => {
                    initiate_flash_process (volatile_data_store.drive_name, volatile_data_store.drive_information, volatile_data_store.disk_information);
                    return false;
                });                    
            }
        });        
        
        warning_label = new Gtk.Label ("Disk Image Not Selected");
        warning_label.halign = Gtk.Align.START;
        warning_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
        
        warning_description = new Gtk.Label ("An operating system image is not selected");
        warning_description.halign = Gtk.Align.START;
        warning_description.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        
        var warning_grid = new Gtk.Grid ();
        warning_grid.attach (warning_label, 0, 0);
        warning_grid.attach (warning_description, 0, 1);
        
        warning_logo = new Gtk.Image ();
        warning_logo.gicon = new ThemedIcon ("dialog-warning");
        warning_logo.pixel_size = 48;
        
        warning_action_button = new Gtk.Button ();
        warning_action_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        warning_action_button.label = "Select Disk Image";
        warning_action_button.halign = Gtk.Align.END;
        warning_action_button.clicked.connect (() =>{ user_selection_completed (0); }); 
        
        insufficient_param_alert = new Gtk.Grid ();
        insufficient_param_alert.column_spacing = 10;
        insufficient_param_alert.row_spacing = 10;
        insufficient_param_alert.attach (warning_logo, 0, 0);
        insufficient_param_alert.attach (warning_grid, 1, 0);
        insufficient_param_alert.attach (warning_action_button, 1, 1);
        
        wait_spinner = new Gtk.Spinner ();
        wait_spinner.height_request = 48;
        wait_spinner.width_request = 48;
        wait_spinner.start ();
        
        wait_label = new Gtk.Label ("Waiting for Confirmation");
        wait_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
        
        wait_grid = new Gtk.Grid ();
        wait_grid.hexpand = true;
        wait_grid.vexpand = true;
        wait_grid.column_spacing = 10;
        wait_grid.halign = Gtk.Align.CENTER;
        wait_grid.valign = Gtk.Align.CENTER;
        wait_grid.attach (wait_spinner, 0, 0);
        wait_grid.attach (wait_label, 1, 0);
        
        this.vexpand = true;
        this.hexpand = true;
        this.row_spacing = 6;
        this.valign = Gtk.Align.CENTER;
        this.halign = Gtk.Align.CENTER;
                
        //Attach Elements to Grid
        attach (insufficient_param_alert, 0, 0);
    }
    
    private void swap_wait_grid (int grid_id) {
        switch (grid_id) {
            case 0: {
                wait_label.label = "Waiting for Confirmation";
                break;
            }
            
            case 1: {
                wait_label.label = "Waiting for Authentication";
                break;
            }            
        }
    }
    
    private void show_disk_warning () {
        remove_row (0);
        attach (insufficient_param_alert, 0, 0);
            
        warning_label.label = "Disk Image Not Selected";
        warning_description.label = "An operating system image is not selected";
        warning_logo.gicon = new ThemedIcon ("dialog-warning");        
        warning_action_button.label = "Select Disk Image";
        warning_action_button.clicked.connect (() =>{ user_selection_completed (0); });
    }
    
    private void show_drive_warning () {
        remove_row (0);
        attach (insufficient_param_alert, 0, 0);
                
        warning_label.label = "Flash Drive Not Selected";
        warning_description.label = "A Bootable Media Drive is not selected";
        warning_logo.gicon = new ThemedIcon ("dialog-warning");        
        warning_action_button.label = "Select Flash Drive";
        warning_action_button.clicked.connect (() =>{ user_selection_completed (1); });
    }
    
    private void show_cancelled_page () {
        remove_row (0);
        attach (insufficient_param_alert, 0, 0);
                
        warning_label.label = "Flash Operation Cancelled";
        warning_description.label = "You have cancelled the flash operation";
        warning_logo.gicon = new ThemedIcon ("dialog-error");
        warning_action_button.label = "Go Back";
        warning_action_button.clicked.connect (() =>{ user_selection_completed (0); });
    }    
    
    private void show_waiting_status () {
        remove_row (0);
        attach (wait_grid, 0, 0);
    }
    
    private void initiate_flash_process (string drive_name, string drive_unix, string disk_path) {        
        confirmation_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            "All Data in " + drive_name + " will be ERASED",
            "<b>" + drive_name + "</b> will be <b>ERASED</b> and <b>" + disk_path.substring (disk_path.last_index_of("/") + 1) + "</b> will be written in the drive. Are you sure?",
            "drive-removable-media",
            Gtk.ButtonsType.CANCEL
        );
        
        confirmation_dialog.response.connect ((response_id) => {
           if (response_id == Gtk.ResponseType.ACCEPT) {
               //GET AUTH AND START FLASH
               confirmation_dialog.destroy ();
           } else {
                volatile_data_store.drive_information = "";
                volatile_data_store.disk_information = "";                
                volatile_data_store.drive_name = "";
                volatile_data_store.is_flash_cancelled = false;
                show_cancelled_page ();                            
                confirmation_dialog.destroy ();
           }
        });
        
        confirmation_dialog.badge_icon = new ThemedIcon ("dialog-warning");        
        
        confirmation_dialog.show_all ();
    }    
}
