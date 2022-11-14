const std = @import("std");
const raylib = @import("./raylib/raylib.zig");
const tile = @import("./tile.zig");


pub fn main() void {
    raylib.InitWindow(1920, 1080, "Test");





    while(!raylib.WindowShouldClose()){
        raylib.BeginDrawing();
            raylib.ClearBackground(raylib.RAYWHITE);

        raylib.EndDrawing();
    }

    raylib.CloseWindow();
}