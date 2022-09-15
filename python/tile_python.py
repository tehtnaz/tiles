#pip3 install raylib
from pyray import *
from raylib.colors import *

#pip3 install multipledispatch
from multipledispatch import dispatch

class Tile:
    type = 0
    def __init__(self, type):
        self.type = type

tileTextureArray: list[Texture2D] = []
tileTextureArraySize = 0

# List of every tile
tileList: list[Tile] = []


def draw_texture_background(tex: Texture2D, scale, tint: Color):
    draw_texture_tiled(tex, (0, 0, tex.width, tex.height), (0, 0, get_screen_width(), get_screen_height()), (), 0, scale, tint)

def draw_tile_background(tile: Tile, scale, tint: Color):
    draw_texture_tiled(tileTextureArray[tile.type], (0, 0, tileTextureArray[tile.type].width, tileTextureArray[tile.type].height), (0, 0, get_screen_width(), get_screen_height()), (), 0, scale, tint)

# Draw tileList
def draw_tile_varied(mapWidth, scale, tint: Color):
    if len(tileList) == 0:
        print("PYTILE_ERROR: Tried rendering empty tile list. Skipping...")
        return
    posx = 0.0
    largestHeight = 0
    index = 0

    for selectedTile in tileList:

        if(selectedTile.type >= len(tileTextureArray)):
            print("PYTILE_ERROR: Tried rendering texture outside of tileTextureArray. Array Size: ", len(tileTextureArray), " Requested index: ", selectedTile.type)
            continue
        else:
            temp = tileTextureArray[selectedTile.type]
        
        # get largest
        if (temp.height > largestHeight):
            largestHeight = temp.height
        if (index % mapWidth == 0): 
            posx = 0.0

        draw_texture_ex(temp, (posx, int(index / mapWidth) * largestHeight * scale), 0, scale, tint)
        posx += temp.width * scale
        print("PYTILE_INFO: DEBUG: DrawTileVaried - ", posx, index % mapWidth, index)

        index += 1

# Returns ID of new tile texture
def new_tile_texture(texture: Texture2D):
    tileTextureArray.append(texture)
    return (len(tileTextureArray) - 1)

# add tile using new class instance
@dispatch (Tile)
def add_new_tile(tile: Tile):
    tileList.append(tile)
    return tile

# add tile using parameters (should be deprecated, imo)
@dispatch (int)
def add_new_tile(type: int):
    new_tile = Tile(type)
    tileList.append(new_tile)
    return new_tile


def unload_tile_texture_array():
    for tileTexture in tileTextureArray:
        unload_texture(tileTexture)
    del tileTextureArray[:]
    print("PYTILE_INFO: UNLOAD_TILE_TEXTURE_ARRAY: All textures unloaded")

def unload_all_tile_data():
    unload_tile_texture_array()
    del tileList[:]
    print("PYTILE_INFO: UNLOAD_ALL_TILE_DATA: All tiles deleted (unloaded)")
