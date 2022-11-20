const std = @import("std");
const ArrayList = std.ArrayList;
const raylib = @import("./raylib/raylib.zig");


pub const Tile = struct {
    tileType: usize
};

var tile_heap = std.heap.GeneralPurposeAllocator(.{}){};
const tile_allocator = tile_heap.allocator();
var tileList = ArrayList(Tile).init(tile_allocator);

var texture_heap = std.heap.GeneralPurposeAllocator(.{}){};
const texture_allocator = texture_heap.allocator();
var tileTextureList = ArrayList(raylib.Texture2D).init(texture_allocator);

const stdout = std.io.getStdOut().writer();

pub fn drawTextureBackground(tex: raylib.Texture2D, scale: f32, tint: raylib.Color) void {
    raylib.DrawTextureTiled(
        tex, 
        .{.x = 0, .y = 0, .width = @intToFloat(f32, tex.width), .height = @intToFloat(f32, tex.height)}, 
        .{.x = 0, .y = 0, .width = @intToFloat(f32, raylib.GetScreenWidth()), .height = @intToFloat(f32, raylib.GetScreenHeight())}, 
        .{.x = 0, .y = 0}, 0, scale, tint);
}
pub fn drawTileBackground(tile: Tile, scale: f32, tint: raylib.Color) void {
    raylib.DrawTextureTiled(
        tileTextureList.items[tile.tileType],
        .{.x = 0, .y = 0, .width = @intToFloat(f32, tileTextureList.items[tile.tileType].width), .height = @intToFloat(f32, tileTextureList.items[tile.tileType].height)},
        .{.x = 0, .y = 0, .width = @intToFloat(f32, raylib.GetScreenWidth()), .height = @intToFloat(f32, raylib.GetScreenHeight())},
        .{.x = 0, .y = 0}, 0, scale, tint);
}

pub fn drawTileVaried(mapWidth: u32, scale: f32, tint: raylib.Color) !void{
    if(tileList.items.len == 0){
        try stdout.print("ERROR - zigTile : Tried rendering an empty tile list. Skipping...", .{});
        return;
    }

    var temp: raylib.Texture2D = undefined;
    var posx: f32 = 0.0;
    var largestHeight: i32 = 0;
    var index: usize = 0;

    //there IS a "index" in zig, but i'd still have to skip counting any failed items, so might as well manually use an index
    for(tileList.items) |selectedTile| {
        //try stdout.print("ZIGTILE_ERROR: Tried rendering texture outside of tileTextureArray. Array Size: {} Requested index: {}\n", .{tileList.items.len, selectedTile.tileType});
        if(selectedTile.tileType >= tileTextureList.items.len){
            try stdout.print("ZIGTILE_ERROR: Tried rendering texture outside of tileTextureArray. Array Size: {} Requested index: {}\n", .{tileTextureList.items.len, selectedTile.tileType});
            continue;
        }else{
            temp = tileTextureList.items[selectedTile.tileType];
        }
        //get largest
        if(temp.height > largestHeight){
            largestHeight = temp.height;
        }
        if(index % mapWidth == 0){
            posx = 0;
        }
        raylib.DrawTextureEx(temp, .{.x = posx, .y = @intToFloat(f32, ((index / mapWidth) * @intCast(usize, largestHeight))) * scale}, 0, scale, tint);
        posx += @intToFloat(f32, temp.width) * scale;
        try stdout.print("ZIGTILE_DEBUG: drawTileVaried - {} {} {}\n", .{posx, index % mapWidth, index});

        index += 1;
    }
}

pub fn newTileTexture(tex: raylib.Texture2D) !usize {
    try stdout.print("added new item\n", .{});
    try tileTextureList.append(tex);
    return tileTextureList.items.len - 1;
}

pub fn addNewTile(tileType: usize) !Tile {
    const newTile = Tile{.tileType = tileType};
    try tileList.append(newTile);
    return newTile;
}

pub fn unloadTileTextureArray() !void{
    for(tileTextureList.items) |item| {
        raylib.UnloadTexture(item);
    }
    tileTextureList.clearAndFree();
    try stdout.print("ZIGTILE_INFO: unloadTileTextureArray - All textures unloaded\n", .{});
}

pub fn unloadAllTileData() !void{
    try unloadTileTextureArray();
    tileList.clearAndFree();
    try stdout.print("ZIGTILE_INFO: unloadAllTileData - All textures cleared (unloaded)\n", .{});
}