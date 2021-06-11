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

public class Marquer.Widgets.ISOChooser : Granite.Dialog {
    static ISOChooser _instance = null;
    public static ISOChooser instance {
        get {
            if (_instance == null)
                _instance = new ISOChooser ();
                return _instance;
        }
    }
                
    public ISOChooser () {
        Object (
            window_position: Gtk.WindowPosition.CENTER_ON_PARENT,
            width_request: 850,
            height_request: 600                      
        );
    }
    
    construct {            
        var file_browser = new Gtk.FileChooserWidget (Gtk.FileChooserAction.OPEN);
        var dialog_header = new Granite.HeaderLabel ("Choose a Disk Image File");
        
        var browser_frame = new Gtk.Frame ("");
        browser_frame.get_label_widget ().destroy ();  
        browser_frame.add (file_browser);      
        
        var grid_main = new Gtk.Grid ();
        grid_main.margin_left = 3;
        grid_main.margin_right = 3;
        grid_main.attach (dialog_header, 0, 0);
        grid_main.attach (browser_frame, 0, 1);
        
        get_content_area ().add (grid_main);
        add_button ("Cancel", Gtk.ResponseType.CANCEL);
        
        var suggested_button = add_button ("Select Disk Image", Gtk.ResponseType.ACCEPT);
        suggested_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        
        response.connect (dialog_button_click);
        
        show_all ();
    }
    
    private void dialog_button_click (int response_id) {
        if (response_id == Gtk.ResponseType.ACCEPT) {
            //DO SOMETHING
        }
        
        destroy ();        
    }
}
