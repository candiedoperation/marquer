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
    private Marquer.Widgets.LeftStartFlash left_start_flash;
    private Marquer.Widgets.RightSelectDisk right_select_disk;
    private Marquer.Widgets.RightSelectDrive right_select_drive;
    private Marquer.Widgets.RightStartFlash right_start_flash;
    private Marquer.Utils.VolatileDataStore volatile_data_store;

    public MainWindow () {
        Object (
            resizable: false,
            title: "Marquer",
            window_position: Gtk.WindowPosition.CENTER,
            width_request: 1060,
            height_request: 660
        );
    }

    construct {
        volatile_data_store = Marquer.Utils.VolatileDataStore.instance;

        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();

        gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
        });

        left_select_disk = new Marquer.Widgets.LeftSelectDisk ();
        left_select_drive = new Marquer.Widgets.LeftSelectDrive();
        left_start_flash = new Marquer.Widgets.LeftStartFlash();

        right_select_disk = new Marquer.Widgets.RightSelectDisk ();
        right_select_drive = new Marquer.Widgets.RightSelectDrive ();
        right_start_flash = new Marquer.Widgets.RightStartFlash ();

        right_carousel = new Hdy.Carousel ();
        right_carousel.vexpand = true;
        right_carousel.page_changed.connect(right_carousel_page_changed);

        right_carousel.add (right_select_disk);
        right_carousel.add (right_select_drive);
        right_carousel.add (right_start_flash);

        right_select_disk.user_selection_completed.connect((signal_handler) => {
            if (volatile_data_store.drive_information == "") {
                right_carousel.scroll_to (right_select_drive);
            } else {
                right_carousel.scroll_to (right_start_flash);
            }
        });

        right_select_drive.user_selection_completed.connect((signal_handler) => {
            if (volatile_data_store.disk_information == "") {
                right_carousel.scroll_to (right_select_disk);
            } else {
                right_carousel.scroll_to (right_start_flash);
            }
        });

        right_start_flash.user_selection_completed.connect((signal_handler, goto_page) => {
            switch (goto_page) {
                case -1: {
                    right_carousel.interactive = false;
                    break;
                }

                case 0: {
                    right_carousel.scroll_to (right_select_disk);
                    break;
                }

                case 1: {
                    right_carousel.scroll_to (right_select_drive);
                    break;
                }

                case 2: {
                    right_carousel.scroll_to (right_start_flash);
                    break;
                }
            }
        });

        var carousel_indicator = new Hdy.CarouselIndicatorLines ();
        carousel_indicator.set_carousel(right_carousel);

        left_grid = new Gtk.Grid ();
        left_grid.vexpand = true;
        left_grid.width_request = 280;
        left_grid.attach(left_select_disk, 0, 0);

        right_grid = new Gtk.Grid ();
        right_grid.vexpand = true;
        right_grid.attach(right_carousel, 0, 0);
        right_grid.attach(carousel_indicator, 0, 1);

        grid_main = new Gtk.Grid();
        grid_main.margin = 12;
        grid_main.attach(left_grid, 0, 0, 1, 1);
        grid_main.attach(right_grid, 1, 0, 3, 1);

        var hdy_header = new Hdy.HeaderBar ();
        hdy_header.show_close_button = true;
        hdy_header.decoration_layout = "close:";
        hdy_header.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        var hdy_grid = new Gtk.Grid ();
        hdy_grid.attach (hdy_header, 0, 0);
        hdy_grid.attach (grid_main, 0, 1);

        var window_handle = new Hdy.WindowHandle ();
        window_handle.add (hdy_grid);

        add (window_handle);
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

            case 2: {
                left_grid.remove_row (0);
                left_grid.attach (left_start_flash, 0, 0);
                show_all();
                break;
            }
        }
    }
}

