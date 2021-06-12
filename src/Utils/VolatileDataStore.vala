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

public class Marquer.Utils.VolatileDataStore : GLib.Object {
    public string disk_information { get; set; default = ""; }
    public string drive_information { get; set; default = ""; }
    
    [CCode(notify=false)]
    public string drive_name { get; set; default = ""; }    
    public bool is_flash_cancelled { get; set; default = false; }
    public Json.Object connected_drives;
    
    private static VolatileDataStore _instance = null;
    
    public static VolatileDataStore instance {
        get {
            if (_instance == null)
                _instance = new VolatileDataStore ();
                return _instance;
        }
    } 
      
    public VolatileDataStore () {
        connected_drives = new Json.Object ();
    }

    construct {
               
    }
}
