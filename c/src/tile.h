#ifndef TILE_H
#define TILE_H

    #include "raylib.h"
    #include <stdlib.h>
    #include "config.h"

    typedef struct Tile {
        int type;
        struct Tile* next;
    }Tile;

    void DrawTextureBackground(Texture2D tex, float scale, Color tint);
    void DrawTileBackground(Tile tile, float scale, Color tint);
    // Draw starting from tileTail
    void DrawTileVaried(int mapWidth, float scale, Color tint);

    //Returns ID of new tile texture
    int NewTileTexture(Texture2D texture);

    #if TILE_AUTO_ARRAYSIZE == 0
    // !!!  MUST BE INITIALIZED  !!!
    void SetTileTextureArraySize(int size);

    #endif

    //Automatically allocated
    Tile AddNewTile(int type);

    void UnloadAllTileData();
    void UnloadTileTextureArray();


    // !!! Draw using array instead, Deprecated !!!
    void DrawTileVaried_Array(Tile tile[], int tileNum, int mapWidth);
#endif