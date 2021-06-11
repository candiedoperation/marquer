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

public class Marquer.App : Gtk.Application {
    construct {
        application_id = "com.github.candiedoperation.marquer";
        flags = ApplicationFlags.FLAGS_NONE;
    }

    public override void activate () {
        Hdy.init (); //Initializing LibHandy
        
        var window = new MainWindow ();
        window.application = this;
        window.show_all ();
    }
}

public static int main (string[] args) {
    var application = new Marquer.App ();
    return application.run (args);
}
