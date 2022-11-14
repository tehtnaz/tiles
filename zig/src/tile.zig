const std = @import("std");
const ArrayList = std.ArrayList;
const raylib = @import("./raylib/raylib.zig");


pub const Tile = struct {
    tileType: u32
};

var tile_heap = std.heap.GeneralPurposeAllocator(.{}){};
const tile_allocator = tile.allocator();
var tileList = ArrayList(Tile).init(tile_allocator);

var texture_heap = std.heap.GeneralPurposeAllocator(.{}){};
const texture_allocator = texture.allocator();
var tileTextureList = ArrayList(raylib.Texture2D).init(texture_allocator);

pub fn drawTextureBackground(tex: raylib.Texture2D, scale: f32, tint: raylib.Color) void {
    raylib.DrawTextureTiled(tex, raylib.Rectangle{0, 0, tex.width, tex.height}, raylib.Rectangle{0, 0, raylib.GetScreenWidth(), raylib.GetScreenHeight()}, raylib.Rectangle{0,0,0,0}, 0, scale, tint);
}
pub fn drawTileBackground(tile: Tile, scale: f32, tint: raylib.Color) void {
    raylib.DrawTextureTiled(
        tileTextureList.items[tile.tileType],
        raylib.Rectangle{0, 0, tileTextureList.items[tile.tileType].width, tileTextureList.items[tile.tileType].height},
        raylib.Rectangle{0, 0, raylib.GetScreenWidth(), raylib.GetScreenHeight()},
        raylib.Vector2{0, 0}, 0, scale, tint);
}

pub fn drawTileVaried(mapWidth: u32, scale: f32, tint: raylib.Color){
    
}