from tile_python import *

# Example Project


init_window(1280, 720, "Python Raylib?")

new_tile_texture(load_texture("res/crate.png"))
new_tile_texture(load_texture("res/0.png"))
new_tile_texture(load_texture("res/crate1.png"))

add_new_tile(Tile(10))
add_new_tile(2)
add_new_tile(2)
add_new_tile(2)
add_new_tile(2)
add_new_tile(1)
add_new_tile(3)
add_new_tile(1)
add_new_tile(1)
add_new_tile(0)
add_new_tile(0)
add_new_tile(1)
add_new_tile(0)
add_new_tile(0)
add_new_tile(0)
add_new_tile(0)

while not window_should_close():
    begin_drawing()
    clear_background(RAYWHITE)
    draw_tile_varied(4, 5, WHITE)
    end_drawing()

unload_all_tile_data()
close_window()