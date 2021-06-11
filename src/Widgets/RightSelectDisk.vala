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

public class Marquer.Widgets.RightSelectDisk : Gtk.Grid {
    private Granite.Widgets.WelcomeButton select_optic_file;
    private Granite.Widgets.WelcomeButton download_optic_file;    
    private Granite.Widgets.WelcomeButton close_app;
        
    public RightSelectDisk () {
        Object ();        
    }
    
    construct {
        //Initialize Elements
        
        var browse_file_icon = new Gtk.Image();
        browse_file_icon.gicon = new ThemedIcon("folder-open");
        
        var download_file_icon = new Gtk.Image();
        download_file_icon.gicon = new ThemedIcon("emblem-downloads");
        
        var close_app_icon = new Gtk.Image();
        close_app_icon.gicon = new ThemedIcon("process-stop");                
        
        select_optic_file = new Granite.Widgets.WelcomeButton (browse_file_icon, "Open Disk Image", "Choose an Existing Disk Image");
        download_optic_file = new Granite.Widgets.WelcomeButton (download_file_icon, "Download Disk Image", "Download a Disk Image from the Internet");        
        close_app = new Granite.Widgets.WelcomeButton (close_app_icon, "Close", "Close the Application");
        
        close_app.clicked.connect (close_application);        
        
        this.vexpand = true;
        this.hexpand = true;
        this.row_spacing = 6;
        this.valign = Gtk.Align.CENTER;
        this.halign = Gtk.Align.CENTER;
                
        //Attach Elements to Grid
        attach (select_optic_file, 0, 0);
        attach (download_optic_file, 0, 1);
        attach (close_app, 0, 2);
    }
    
    private void close_application () {
         GLib.Application.get_default ().quit ();
    }
}
