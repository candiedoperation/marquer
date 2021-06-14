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
    private Marquer.Widgets.StartFlashWarning start_flash_warning;
    private Marquer.Widgets.StartFlashWaiting start_flash_waiting;
    private Marquer.Widgets.RightFlashingProgress flashing_progress_widget;
    private Marquer.Utils.VolatileDataStore volatile_data_store;
    private Granite.MessageDialog confirmation_dialog;
    private string drive_name = "";
    private string drive_unix = "";
    private string disk_path = "";
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
                show_waiting_status ("Waiting for Confirmation");
                
                Timeout.add (500, () => {
                    drive_name = volatile_data_store.drive_name;
                    drive_unix = volatile_data_store.drive_information; 
                    disk_path = volatile_data_store.disk_information;
                                
                    initiate_flash_process ();
                    return false;
                });                    
            }
        });
        
        flashing_progress_widget = new Marquer.Widgets.RightFlashingProgress ();
        
        start_flash_warning = new StartFlashWarning ("Disk Image Not Selected", "An operating system image is not selected", new ThemedIcon ("dialog-warning"), "Select Disk Image");
        start_flash_warning.warning_action_button.clicked.connect (() => { user_selection_completed (0); });        
        
        start_flash_waiting = new Marquer.Widgets.StartFlashWaiting ("Waiting for Confirmation");
        
        this.vexpand = true;
        this.hexpand = true;
        this.row_spacing = 6;
        this.valign = Gtk.Align.CENTER;
        this.halign = Gtk.Align.CENTER;
                
        //Attach Elements to Grid
        attach (start_flash_warning, 0, 0);
    }
    
    private void show_disk_warning () {
        start_flash_warning.purge ();
        start_flash_warning = new StartFlashWarning ("Disk Image Not Selected", "An operating system image is not selected", new ThemedIcon ("dialog-warning"), "Select Disk Image");
        start_flash_warning.warning_action_button.clicked.connect (() => { user_selection_completed (0); });
                
        remove_row (0);
        attach (start_flash_warning, 0, 0);
    }
    
    private void show_drive_warning () {
        start_flash_warning.purge ();
        start_flash_warning = new StartFlashWarning ("Flash Drive Not Selected", "Boot Media Drive is not selected", new ThemedIcon ("dialog-warning"), "Select Flash Drive");
        start_flash_warning.warning_action_button.clicked.connect (() => { user_selection_completed (1); });
                
        remove_row (0);
        attach (start_flash_warning, 0, 0);        
    }
    
    private void show_cancelled_page () {
        start_flash_warning.purge ();
        start_flash_warning = new StartFlashWarning ("Flash Operation Cancelled", "You have cancelled the flash operation", new ThemedIcon ("dialog-error"), "Go Back");
        start_flash_warning.warning_action_button.clicked.connect (() => { user_selection_completed (0); });
                
        remove_row (0);
        attach (start_flash_warning, 0, 0);        
    }    
    
    private void show_authentication_failed () {        
        start_flash_warning.purge ();
        start_flash_warning = new StartFlashWarning ("Authentication Failed", "Authentication required to Write Image to Flash Drive", new ThemedIcon ("dialog-error"), "Reauthenticate");
        start_flash_warning.warning_action_button.clicked.connect (() => { start_flash_process (); });
        
        remove_row (0);
        attach (start_flash_warning, 0, 0);                 
    }
    
    private void update_flashing_progress (string description, string terminal_text, double progress) {        
        this.get_children ().foreach ((child) => {
            if ((child != flashing_progress_widget)) {
                remove_row (0);
                attach (flashing_progress_widget, 0, 0);                
            }
        });
            
        flashing_progress_widget.description_label.label = description;
        flashing_progress_widget.flashing_progress.fraction = progress;
        flashing_progress_widget.terminal.buffer.text += ("\n" + terminal_text);
    }    
    
    private void show_waiting_status (string status) {
        start_flash_waiting.purge ();
        start_flash_waiting = new Marquer.Widgets.StartFlashWaiting (status);
        
        remove_row (0);
        attach (start_flash_waiting, 0, 0);
    }
    
    private void initiate_flash_process () {        
        confirmation_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            "All Data in " + drive_name + " will be ERASED",
            "<b>" + drive_name + " (" + drive_unix + ") </b> will be <b>ERASED</b> and <b>" + disk_path.substring (disk_path.last_index_of("/") + 1) + "</b> will be written in the drive. Are you sure?",
            "drive-removable-media",
            Gtk.ButtonsType.CANCEL
        );
        
        var proceed_flash_button = new Gtk.Button.with_label ("Start Flashing");
        proceed_flash_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
        confirmation_dialog.add_action_widget (proceed_flash_button, Gtk.ResponseType.ACCEPT);        
        
        confirmation_dialog.response.connect ((response_id) => {
           if (response_id == Gtk.ResponseType.ACCEPT) {
               //GET AUTH AND START FLASH
               start_flash_process ();
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
    
    private void start_flash_process () {
        user_selection_completed (-1);
        show_waiting_status ("Unmounting Drives");
        Timeout.add (500, () => {
            drive_manager.unmount_volumes (drive_unix);
        
            show_waiting_status ("Waiting for Authentication");
            Timeout.add (500, () => {
                connect_flash_process_channel ();
                return false;
            });            
        });
    }
    
    private void connect_flash_process_channel () {
        try {
            string[] spawn_args = {"pkexec", "--user", "root", "dd", "bs=8M", "if=" + disk_path, "of=" + drive_unix, "conv=fdatasync", "status=progress"};
            string[] spawn_env = Environ.get ();
            Pid child_pid;

            int standard_input;
            int standard_output;
            int standard_error;

            Process.spawn_async_with_pipes ("/",
                spawn_args,
                spawn_env,
                SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
                null,
                out child_pid,
                out standard_input,
                out standard_output,
                out standard_error);

            // stdout:
            IOChannel output = new IOChannel.unix_new (standard_output);
            output.add_watch (IOCondition.IN | IOCondition.HUP, (channel, condition) => {
                return process_line (channel, condition, "stdout");
            });

            // stderr:
            IOChannel error = new IOChannel.unix_new (standard_error);
            error.add_watch (IOCondition.IN | IOCondition.HUP, (channel, condition) => {                     
                return process_line (channel, condition, "stderr");                   
            });

            ChildWatch.add (child_pid, (pid, status) => {
                // Triggered when the child indicated by child_pid exits
                Process.close_pid (pid);                    
            });
            
        } catch (SpawnError e) {
            print ("Error: %s\n", e.message);
        }        
    }
    
    private bool process_line (IOChannel channel, IOCondition condition, string stream_name) {
        if (condition == IOCondition.HUP) {
            print ("%s: Marquer Connection Broken\n", stream_name);
            return false;
        }

        try {
            string line;
            channel.read_line (out line, null, null);
            print ("%s: %s", stream_name, line);
            
            if (stream_name == "stderr") {
                if ("Request dismissed" in line) {
                    show_authentication_failed ();
                } else {
                    //SHOW PROCESS FAILED
                }                
            } else if (stream_name == "stdout") {
                if ("Marquer Connection Broken" in line) {
                    //SHOW SUCCESS
                } else if (0 == 1) {
                    //CHK FOR UMOUNT OPUT
                } else {
                    update_flashing_progress ("0% (0 MB/s)", line, 0.2);
                }
            }
            
        } catch (IOChannelError e) {
            print ("%s: IOChannelError: %s\n", stream_name, e.message);
            return false;
        } catch (ConvertError e) {
            print ("%s: ConvertError: %s\n", stream_name, e.message);
            return false;
        }

        return true;
    }   
}
