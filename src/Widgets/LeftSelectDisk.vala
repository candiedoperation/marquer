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

public class Marquer.Widgets.LeftSelectDisk : Gtk.Grid {
    private Gtk.Label panel_left_title;
    private Gtk.Label panel_left_subtitle;
    private Gtk.Image panel_left_image;
    
    public LeftSelectDisk () {
        Object ();        
    }
    
    construct {
        panel_left_title = new Gtk.Label("Select Disk Image");
        panel_left_title.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);
        
        panel_left_subtitle = new Gtk.Label("Select an ISO or an image file");
        panel_left_subtitle.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        
        panel_left_image = new Gtk.Image(); 
        panel_left_image.gicon = new ThemedIcon("media-optical");
        panel_left_image.pixel_size = 100;     
        
        this.vexpand = true;
        this.hexpand = true;
        this.row_spacing = 6;
        this.valign = Gtk.Align.CENTER;
        this.halign = Gtk.Align.CENTER;
                
        attach(panel_left_image, 0, 0);
        attach(panel_left_title, 0, 1);
        attach(panel_left_subtitle, 0, 2);
    }
}
