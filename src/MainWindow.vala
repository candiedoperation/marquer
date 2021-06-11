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

public class Marquer.MainWindow : Hdy.ApplicationWindow {
    private static GLib.Settings settings;
    private Gtk.Grid grid_main;
    private Gtk.Grid left_grid;
    private Gtk.Grid right_grid;
    private Hdy.Carousel right_carousel;
    private Marquer.Widgets.LeftSelectDisk left_select_disk;
    private Marquer.Widgets.LeftSelectDrive left_select_drive;    
    private Marquer.Widgets.RightSelectDisk right_select_disk;
    private Marquer.Widgets.RightSelectDrive right_select_drive;

    public MainWindow () {
        Object (
            resizable: false,
            title: "Marquer",
            width_request: 1060,
            height_request: 660
        );
    }

    construct {
        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();

        gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
        });
        
        left_select_disk = new Marquer.Widgets.LeftSelectDisk ();
        left_select_drive = new Marquer.Widgets.LeftSelectDrive();        
        
        right_select_disk = new Marquer.Widgets.RightSelectDisk ();
        right_select_drive = new Marquer.Widgets.RightSelectDrive ();        
        
        right_carousel = new Hdy.Carousel ();
        right_carousel.vexpand = true;
        right_carousel.page_changed.connect(right_carousel_page_changed);
        
        right_carousel.add (right_select_disk);
        right_carousel.add (right_select_drive);
        
        var carousel_indicator = new Hdy.CarouselIndicatorDots ();
        carousel_indicator.set_carousel(right_carousel);
        
        left_grid = new Gtk.Grid ();
        left_grid.vexpand = true;
        left_grid.attach(left_select_disk, 0, 0);
        
        right_grid = new Gtk.Grid ();
        right_grid.vexpand = true;
        right_grid.attach(right_carousel, 0, 0);
        right_grid.attach(carousel_indicator, 0, 1);                        
        
        grid_main = new Gtk.Grid();
        grid_main.margin = 12;
        grid_main.attach(left_grid, 0, 0, 1, 1);
        grid_main.attach(right_grid, 1, 0, 3, 1);
        
        var header_bar = new Hdy.WindowHandle();
        header_bar.add(grid_main);
        
        add(header_bar);
        show_all();
    }
    
    private void right_carousel_page_changed(uint page_index) {
        switch (page_index) {
            case 0: {
                left_grid.remove_row (0);
                left_grid.attach (left_select_disk, 0, 0);
                show_all();
                break;
            }
            
            case 1: {
                left_grid.remove_row (0);
                left_grid.attach (left_select_drive, 0, 0);
                show_all();
                break;
            }
        }
    }
}

