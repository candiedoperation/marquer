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

public class Marquer.Utils.DriveManager : GLib.Object {
    private GLib.VolumeMonitor device_manager;
    public signal void drive_list_update (List<Drive> drive_list);
    
    public DriveManager () {
                        
    }

    construct {
        device_manager = GLib.VolumeMonitor.get ();
        
        device_manager.drive_connected.connect((drive_list) => {
            get_connected_drives ();
        });
        
        device_manager.drive_disconnected.connect((drive_list) => {
            get_connected_drives ();
        });        
    }
    
    public void get_connected_drives () {
        drive_list_update (device_manager.get_connected_drives ());
    }
    
    public void unmount_volumes (string drive_unix) {
        device_manager.get_mounts ().foreach ((mount) => {
            if (mount.get_drive ().get_identifier (GLib.DRIVE_IDENTIFIER_KIND_UNIX_DEVICE) == drive_unix) {
                //Mount matches with selected drive
                try {
                    GLib.MountOperation unmount_operation = new GLib.MountOperation (); 
                    mount.unmount_with_operation (GLib.MountUnmountFlags.FORCE, unmount_operation);                    
                } catch (GLib.Error mount_error) {
                    //DRIVE UNMOUNT FAILED
                }
            }
        });
    }
}
