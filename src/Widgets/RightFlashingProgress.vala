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

public class Marquer.Widgets.RightFlashingProgress : Gtk.Grid {
    public Gtk.Label description_label;
    public Gtk.ProgressBar flashing_progress;
    public Gtk.TextView terminal;
    
    public RightFlashingProgress () {
        Object ();                
    }
    
    construct {
        var title_label = new Gtk.Label ("Flashing and Verifying");
        title_label.hexpand = true;
        title_label.halign = Gtk.Align.START;
        
        unowned var title_label_context = title_label.get_style_context ();
        title_label_context.add_class (Granite.STYLE_CLASS_H2_LABEL);
        title_label_context.add_class (Granite.STYLE_CLASS_ACCENT);
        
        description_label = new Gtk.Label ("0% (0 MB/s)");
        description_label.hexpand = true;
        description_label.halign = Gtk.Align.START;
        
        unowned var description_label_context = description_label.get_style_context ();
        description_label_context.add_class (Granite.STYLE_CLASS_H3_LABEL);
        
        flashing_progress = new Gtk.ProgressBar ();
        flashing_progress.hexpand = true;
        
        terminal = new Gtk.TextView ();
        terminal.set_top_margin (5);
        terminal.set_bottom_margin (5);
        terminal.set_right_margin (5);
        terminal.set_left_margin (5);
        terminal.editable = false;
        terminal.hexpand = true;
        terminal.buffer.text = "Console Pipe Output:";
        terminal.get_style_context ().add_class (Granite.STYLE_CLASS_TERMINAL);
        
        var terminal_parent = new Gtk.ScrolledWindow (null, null);
        terminal_parent.height_request = 300;
        terminal_parent.add (terminal);        
        
        var terminal_expand = new Gtk.Expander ("Technical Information");
        terminal_expand.margin_top = 10;
                
        var progress_grid = new Gtk.Grid ();
        progress_grid.hexpand = true;
        progress_grid.vexpand = true;
        progress_grid.row_spacing = 5;
        progress_grid.column_spacing = 10;
        progress_grid.valign = Gtk.Align.CENTER;
        
        progress_grid.attach (title_label, 0, 0);
        progress_grid.attach (description_label, 0, 1);
        progress_grid.attach (flashing_progress, 0, 2);
        progress_grid.attach (terminal_expand, 0, 3);
        
        terminal_expand.activate.connect(() => {
            if (terminal_expand.expanded == true) {
                //Hide terminal
                progress_grid.remove (terminal_parent);
                show_all ();
            } else {
                //Show terminal
                progress_grid.attach (terminal_parent, 0, 4);
                show_all ();
            }
        });                        
        
        this.vexpand = true;
        this.hexpand = true;
        this.width_request = 500;        
        this.row_spacing = 6;        
        
        add (progress_grid);
        show_all ();
    }
    
    public void purge () {
        this.destroy ();
    }
}
