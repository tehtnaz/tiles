const std = @import("std");
const raylib = @import("./raylib/raylib.zig");
const tile = @import("./tile.zig");
//const tile2 = @cImport({
//    @cDefine("TILE_AUTO_ARRAYSIZE", "1");
//    @cDefine("TILE_DEBUG_MSG", "0");
//    @cInclude("tile.h");});


//exclamation mark means able to handle errors
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    raylib.InitWindow(1920, 1080, "Test");
    
    try stdout.print("dir: {s}\n", .{raylib.GetWorkingDirectory()});

    _ = try tile.newTileTexture(raylib.LoadTexture("res/crate.png"));
    _ = try tile.newTileTexture(raylib.LoadTexture("res/0.png"));
    _ = try tile.newTileTexture(raylib.LoadTexture("res/crate1.png"));

    _ = try tile.addNewTile(10);
    _ = try tile.addNewTile(2);
    _ = try tile.addNewTile(2);
    _ = try tile.addNewTile(2);
    _ = try tile.addNewTile(2);
    _ = try tile.addNewTile(1);
    _ = try tile.addNewTile(3);
    _ = try tile.addNewTile(1);
    _ = try tile.addNewTile(1);
    _ = try tile.addNewTile(0);
    _ = try tile.addNewTile(0);
    _ = try tile.addNewTile(1);
    _ = try tile.addNewTile(0);
    _ = try tile.addNewTile(0);
    _ = try tile.addNewTile(0);
    _ = try tile.addNewTile(0);

    while(!raylib.WindowShouldClose()){
        raylib.BeginDrawing();
            raylib.ClearBackground(raylib.RAYWHITE);
            try tile.drawTileVaried(4, 5, raylib.WHITE);
        raylib.EndDrawing();
    }
    try tile.unloadAllTileData();
    raylib.CloseWindow();
}