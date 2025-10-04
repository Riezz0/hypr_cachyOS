#!/usr/bin/env python3

import gi
import os
import shutil
import subprocess
import glob

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GdkPixbuf, Gio

class WallpaperSwitcher(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self, title="Wallpaper Switcher")
        self.set_default_size(600, 400)
        self.set_border_width(10)
        
        # Define paths
        self.home_dir = os.path.expanduser("~")
        self.bg_dir = os.path.join(self.home_dir, ".config", "hypr", "bg")
        self.current_bg = os.path.join(self.bg_dir, "bg.jpg")
        
        # Theme directories
        self.waybar_themes_dir = os.path.join(self.home_dir, ".config", "waybar", "themes")
        self.waybar_style = os.path.join(self.home_dir, ".config", "waybar", "style.css")
        
        self.hyprland_themes_dir = os.path.join(self.home_dir, ".config", "hypr", "themes")
        self.hyprland_colors = os.path.join(self.home_dir, ".config", "hypr", "colors.conf")
        
        self.rofi_themes_dir = os.path.join(self.home_dir, ".config", "rofi", "themes")
        self.rofi_colors = os.path.join(self.home_dir, ".config", "rofi", "launcher", "colors.rasi")
        
        # GTK-4.0 paths
        self.gtk4_config_dir = os.path.join(self.home_dir, ".config", "gtk-4.0")
        self.gtk4_config_file = os.path.join(self.gtk4_config_dir, "gtk.css")
        self.themes_dir = os.path.join(self.home_dir, ".themes")
        
        # Create main vertical box
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.add(vbox)
        
        # Create header
        header = Gtk.Label()
        header.set_markup("<b>Select Wallpaper</b>")
        header.set_halign(Gtk.Align.START)
        vbox.pack_start(header, False, False, 0)
        
        # Create scrolled window for thumbnails
        scrolled_window = Gtk.ScrolledWindow()
        scrolled_window.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        scrolled_window.set_min_content_height(300)
        vbox.pack_start(scrolled_window, True, True, 0)
        
        # Create flow box for thumbnails
        self.flowbox = Gtk.FlowBox()
        self.flowbox.set_max_children_per_line(4)
        self.flowbox.set_selection_mode(Gtk.SelectionMode.SINGLE)
        self.flowbox.set_homogeneous(True)
        self.flowbox.set_column_spacing(10)
        self.flowbox.set_row_spacing(10)
        scrolled_window.add(self.flowbox)
        
        # Create apply button
        self.apply_button = Gtk.Button.new_with_label("Apply")
        self.apply_button.connect("clicked", self.on_apply_clicked)
        self.apply_button.set_sensitive(False)
        vbox.pack_start(self.apply_button, False, False, 0)
        
        # Load wallpapers
        self.load_wallpapers()
        
        # Connect flowbox selection changed signal
        self.flowbox.connect("selected-children-changed", self.on_selection_changed)

    def load_wallpapers(self):
        """Load wallpapers from the background directory, excluding bg.jpg"""
        # Clear existing thumbnails
        for child in self.flowbox.get_children():
            self.flowbox.remove(child)
        
        # Ensure directory exists
        if not os.path.exists(self.bg_dir):
            os.makedirs(self.bg_dir)
            return
        
        # Get all image files
        image_extensions = ['*.jpg', '*.jpeg', '*.png', '*.webp', '*.bmp']
        wallpapers = []
        
        for ext in image_extensions:
            wallpapers.extend(glob.glob(os.path.join(self.bg_dir, ext)))
            wallpapers.extend(glob.glob(os.path.join(self.bg_dir, ext.upper())))
        
        # Filter out bg.jpg
        wallpapers = [wp for wp in wallpapers if os.path.basename(wp) != 'bg.jpg']
        
        if not wallpapers:
            return
        
        # Create thumbnails for each wallpaper
        for wallpaper_path in sorted(wallpapers):
            self.create_thumbnail(wallpaper_path)

    def create_thumbnail(self, image_path):
        """Create a thumbnail widget for the given image path"""
        try:
            # Create thumbnail pixbuf (resize to 150x100)
            pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_size(image_path, 150, 100)
            
            # Create image widget
            image = Gtk.Image.new_from_pixbuf(pixbuf)
            
            # Create event box for click handling with fixed size
            event_box = Gtk.EventBox()
            event_box.add(image)
            event_box.set_size_request(150, 100)  # Fixed size to match thumbnail
            
            # Get filename without extension for theme names
            filename = os.path.basename(image_path)
            name_without_ext = os.path.splitext(filename)[0]
            
            # Check which themes are available
            waybar_theme = os.path.join(self.waybar_themes_dir, f"{name_without_ext}.css")
            hyprland_theme = os.path.join(self.hyprland_themes_dir, f"{name_without_ext}.conf")
            rofi_theme = os.path.join(self.rofi_themes_dir, f"{name_without_ext}.rasi")
            
            # Check if any themes are available
            has_themes = any([
                os.path.exists(waybar_theme),
                os.path.exists(hyprland_theme),
                os.path.exists(rofi_theme)
            ])
            
            # Create label - only show name without extension
            # Only show "No themes" message if no themes are available
            if has_themes:
                label_text = name_without_ext
            else:
                label_text = f"{name_without_ext}\n(No themes)"
            
            label = Gtk.Label(label=label_text)
            label.set_ellipsize(3)  # END ellipsize
            label.set_lines(2 if not has_themes else 1)
            label.set_line_wrap(True)
            label.set_max_width_chars(15)  # Limit text width
            
            # Create vertical box for thumbnail and label with fixed width
            vbox_thumb = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=5)
            vbox_thumb.pack_start(event_box, False, False, 0)
            vbox_thumb.pack_start(label, False, False, 0)
            vbox_thumb.set_size_request(160, has_themes and 130 or 140)  # Adjust height based on content
            
            # Create frame for better visual appearance with fixed size
            frame = Gtk.Frame()
            frame.set_shadow_type(Gtk.ShadowType.ETCHED_IN)
            frame.add(vbox_thumb)
            frame.set_size_request(160, has_themes and 130 or 140)  # Adjust height based on content
            
            # Store the full path and theme names in the frame
            frame.image_path = image_path
            frame.theme_name = f"oomox-{name_without_ext}"
            frame.waybar_theme = waybar_theme
            frame.hyprland_theme = hyprland_theme
            frame.rofi_theme = rofi_theme
            frame.name_without_ext = name_without_ext
            
            # Add to flowbox
            self.flowbox.add(frame)
            
        except Exception as e:
            print(f"Error loading thumbnail for {image_path}: {e}")

    def on_selection_changed(self, flowbox):
        """Handle selection changes"""
        selected = flowbox.get_selected_children()
        self.apply_button.set_sensitive(len(selected) > 0)

    def apply_waybar_theme(self, waybar_theme_path, wallpaper_name):
        """Apply Waybar theme by copying to style.css"""
        try:
            if os.path.exists(waybar_theme_path):
                print(f"Applying Waybar theme: {waybar_theme_path}")
                # Ensure waybar directory exists
                os.makedirs(os.path.dirname(self.waybar_style), exist_ok=True)
                shutil.copy2(waybar_theme_path, self.waybar_style)
                print(f"Waybar theme applied successfully to {self.waybar_style}")
                return True
            else:
                print(f"Waybar theme not found: {waybar_theme_path}")
                return False
        except Exception as e:
            print(f"Error applying Waybar theme: {e}")
            return False

    def apply_hyprland_theme(self, hyprland_theme_path, wallpaper_name):
        """Apply Hyprland theme by copying to colors.conf"""
        try:
            if os.path.exists(hyprland_theme_path):
                print(f"Applying Hyprland theme: {hyprland_theme_path}")
                # Ensure hypr directory exists
                os.makedirs(os.path.dirname(self.hyprland_colors), exist_ok=True)
                shutil.copy2(hyprland_theme_path, self.hyprland_colors)
                print(f"Hyprland theme applied successfully to {self.hyprland_colors}")
                return True
            else:
                print(f"Hyprland theme not found: {hyprland_theme_path}")
                return False
        except Exception as e:
            print(f"Error applying Hyprland theme: {e}")
            return False

    def apply_rofi_theme(self, rofi_theme_path, wallpaper_name):
        """Apply Rofi theme by copying to colors.rasi"""
        try:
            if os.path.exists(rofi_theme_path):
                print(f"Applying Rofi theme: {rofi_theme_path}")
                # Ensure rofi launcher directory exists
                os.makedirs(os.path.dirname(self.rofi_colors), exist_ok=True)
                shutil.copy2(rofi_theme_path, self.rofi_colors)
                print(f"Rofi theme applied successfully to {self.rofi_colors}")
                return True
            else:
                print(f"Rofi theme not found: {rofi_theme_path}")
                return False
        except Exception as e:
            print(f"Error applying Rofi theme: {e}")
            return False

    def apply_gtk4_theme(self, theme_name):
        """Apply GTK-4.0 theme by copying gtk.css file"""
        try:
            # Source theme file path
            source_gtk4_file = os.path.join(self.themes_dir, theme_name, "gtk-4.0", "gtk.css")
            
            if os.path.exists(source_gtk4_file):
                print(f"Applying GTK-4.0 theme: {source_gtk4_file}")
                
                # Ensure target directory exists
                os.makedirs(self.gtk4_config_dir, exist_ok=True)
                
                # Remove existing gtk.css file if it exists
                if os.path.exists(self.gtk4_config_file):
                    os.remove(self.gtk4_config_file)
                    print(f"Removed existing {self.gtk4_config_file}")
                
                # Copy the new theme file
                shutil.copy2(source_gtk4_file, self.gtk4_config_file)
                print(f"GTK-4.0 theme applied successfully to {self.gtk4_config_file}")
                return True
            else:
                print(f"GTK-4.0 theme file not found: {source_gtk4_file}")
                return False
        except Exception as e:
            print(f"Error applying GTK-4.0 theme: {e}")
            return False

    def apply_theme(self, theme_name):
        """Apply the GTK theme using gsettings"""
        try:
            # Apply GTK theme
            subprocess.run([
                'gsettings', 'set', 'org.gnome.desktop.interface', 
                'gtk-theme', theme_name
            ], check=True)
            
            # Apply icon theme
            subprocess.run([
                'gsettings', 'set', 'org.gnome.desktop.interface',
                'icon-theme', theme_name
            ], check=True)
            
            # Apply cursor theme (if applicable)
            subprocess.run([
                'gsettings', 'set', 'org.gnome.desktop.interface',
                'cursor-theme', theme_name
            ], check=True)
            
            print(f"GTK theme applied successfully: {theme_name}")
            return True
        except subprocess.CalledProcessError as e:
            print(f"Error applying GTK theme: {e}")
            return False

    def restart_waybar(self):
        """Restart Waybar to apply new theme"""
        try:
            print("Restarting Waybar...")
            # Kill existing waybar processes
            subprocess.run(['pkill', 'waybar'], capture_output=True)
            # Start waybar (adjust command as needed for your setup)
            subprocess.Popen(['waybar'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            print("Waybar restarted successfully")
            return True
        except Exception as e:
            print(f"Error restarting Waybar: {e}")
            return False

    def reload_hyprland(self):
        """Reload Hyprland configuration"""
        try:
            print("Reloading Hyprland...")
            subprocess.run(['hyprctl', 'reload'], check=True)
            print("Hyprland reloaded successfully")
            return True
        except subprocess.CalledProcessError as e:
            print(f"Error reloading Hyprland: {e}")
            return False

    def on_apply_clicked(self, button):
        """Apply the selected wallpaper and all associated themes"""
        selected = self.flowbox.get_selected_children()
        if not selected:
            return
        
        # Get the selected wallpaper path and theme names
        frame = selected[0].get_child()
        selected_path = frame.image_path
        theme_name = frame.theme_name
        waybar_theme = frame.waybar_theme
        hyprland_theme = frame.hyprland_theme
        rofi_theme = frame.rofi_theme
        name_without_ext = frame.name_without_ext
        
        print(f"\n=== Applying themes for: {name_without_ext} ===")
        
        try:
            # STEP 1: Copy all theme files first
            print("\n--- Step 1: Copying theme files ---")
            
            # Copy selected wallpaper to bg.jpg
            shutil.copy2(selected_path, self.current_bg)
            print(f"Copied wallpaper to: {self.current_bg}")
            
            # Apply Waybar theme (copy only, no restart yet)
            waybar_success = self.apply_waybar_theme(waybar_theme, name_without_ext)
            
            # Apply Hyprland theme (copy only, no reload yet)
            hyprland_success = self.apply_hyprland_theme(hyprland_theme, name_without_ext)
            
            # Apply Rofi theme
            rofi_success = self.apply_rofi_theme(rofi_theme, name_without_ext)
            
            # Apply GTK-4.0 theme
            gtk4_success = self.apply_gtk4_theme(theme_name)
            
            # STEP 2: Apply visual changes
            print("\n--- Step 2: Applying visual changes ---")
            
            # Apply wallpaper using swww
            subprocess.run(['swww', 'img', self.current_bg], check=True)
            print("Applied wallpaper with swww")
            
            # Run pywal16 with the correct command format
            subprocess.run(['wal', '-i', self.current_bg, '--cols16'], check=True)
            print("Ran pywal16")
            
            # Apply GTK theme
            gtk_success = self.apply_theme(theme_name)
            
            # STEP 3: Restart services (do this last)
            print("\n--- Step 3: Restarting services ---")
            
            # Restart Waybar if theme was applied successfully
            if waybar_success:
                self.restart_waybar()
            
            # Reload Hyprland if theme was applied successfully
            if hyprland_success:
                self.reload_hyprland()
            
            print("=== Theme application completed ===\n")
            
        except subprocess.CalledProcessError as e:
            error_msg = f"Error applying wallpaper: {e}"
            print(error_msg)
        except Exception as e:
            error_msg = f"Error: {e}"
            print(error_msg)

def main():
    # Check if required commands are available
    try:
        subprocess.run(['swww', '--version'], capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("Error: swww is not installed or not in PATH")
        return
    
    # Check for gsettings
    try:
        subprocess.run(['gsettings', '--version'], capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("Error: gsettings is not available")
        return
    
    # More lenient check for pywal16
    try:
        subprocess.run(['wal', '--help'], capture_output=True, check=True)
        print("Pywal16 found")
    except (subprocess.CalledProcessError, FileNotFoundError):
        try:
            result = subprocess.run(['which', 'wal'], capture_output=True, text=True, check=True)
            print(f"Pywal16 found at: {result.stdout.strip()}")
        except (subprocess.CalledProcessError, FileNotFoundError):
            print("Warning: wal command not found, but continuing anyway...")
    
    # Create and show application
    win = WallpaperSwitcher()
    win.connect("destroy", Gtk.main_quit)
    win.show_all()
    Gtk.main()

if __name__ == "__main__":
    main()
