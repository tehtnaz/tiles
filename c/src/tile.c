#include "tile.h"
#include <stdio.h>
#include <stdarg.h>
#include "config.h"

static Texture2D* tileTextureArray = NULL;
static int tileTextureArraySize = 0;

// Used for memory resize, do not use
static int totalTextureNum = 0;

// Tail end of Tile LinkedList
// Tail = first one, head = the one guiding it at the end (think... Vectors!)
static Tile* tileTail = NULL;

void DrawTextureBackground(Texture2D tex, float scale, Color tint){
    DrawTextureTiled(tex, (Rectangle){0, 0, tex.width, tex.height}, (Rectangle){0, 0, GetScreenWidth(), GetScreenHeight()}, (Vector2){}, 0, scale, tint);
}

void DrawTileBackground(Tile tile, float scale, Color tint){
    DrawTextureTiled(
        tileTextureArray[tile.type],
        (Rectangle){0, 0, tileTextureArray[tile.type].width, tileTextureArray[tile.type].height},
        (Rectangle){0, 0, GetScreenWidth(), GetScreenHeight()},
        (Vector2){}, 0, scale, tint);
}

// Draw using array instead, Deprecated
void DrawTileVaried_Array(Tile tile[], int tileNum, int mapWidth){
    Texture2D temp;
    int posx = 0, largestHeight = 0;
    for (int i = 0; i < tileNum; i++)
    {
        if (i % mapWidth == 0) posx = 0;
        temp = tileTextureArray[tile[i].type];

        DrawTexture(temp, posx, (i / mapWidth) * largestHeight, WHITE);
        posx += temp.width;

        #if TILE_DEBUG_MSG == 1
            printf("TILE_INFO: DEBUG: DrawTileVaried_Array -  %d %d\n", posx, i % mapWidth);
        #endif

        // get largest
        if (temp.height > largestHeight)
            largestHeight = temp.height;
    }
}

// Draw starting from tileTail
void DrawTileVaried(int mapWidth, float scale, Color tint){
    if(tileTail == NULL){
        printf("TILE_ERROR: Tried rendering NULL tile list. Skipping...\n");
        return;
    }
    Texture2D temp;
    Tile *selectedTile = tileTail;
    float posx = 0, largestHeight = 0;

    for (int i = 0; selectedTile != NULL; i++)
    {
        if(selectedTile->type >= tileTextureArraySize){
            printf(
                "TILE_ERROR: Tried rendering texture outside of tileTextureArray. Array Size: %d Requested index: %d\n", 
                tileTextureArraySize, selectedTile->type);
            selectedTile = selectedTile->next;
            i--;
            continue;
        }else{
            temp = tileTextureArray[selectedTile->type];
        }
        // get largest
        if (temp.height > largestHeight)
            largestHeight = temp.height;
        if (i % mapWidth == 0) posx = 0;

        DrawTextureEx(temp, (Vector2){posx, (i / mapWidth) * largestHeight * scale}, 0, scale, tint);
        posx += temp.width * scale;

        #if TILE_DEBUG_MSG == 1
            printf("TILE_INFO: DEBUG: DrawTileVaried - %f %d %d\n", posx, i % mapWidth, i);
        #endif

        selectedTile = selectedTile->next;
    }
}

//Returns ID of new tile texture
int NewTileTexture(Texture2D texture){
    #if TILE_AUTO_ARRAYSIZE == 1

    if(tileTextureArray == NULL){
        printf("TILE_INFO: NEWTILETEXTURE: Allocated new tileTextureArray\n");
        tileTextureArray = (Texture2D*) malloc(sizeof(Texture2D) * 8);
        totalTextureNum = 8;
    }

    #endif

    if(tileTextureArraySize == totalTextureNum) {
        #if TILE_AUTO_ARRAYSIZE == 0
            printf("TILE_ERROR: Tried loading more textures than allowed\n    Max Set to: %d (If it's zero, you may have forgot to set the array size).\n    You can also define TILE_AUTO_ARRAYSIZE to remove that initializing step\n    Skipping...\n", totalTextureNum);
            return 0;
        #else
            printf("TILE_INFO: NEWTILETEXTURE: Resized tileTextureArray\n");
            totalTextureNum *= 2;
            tileTextureArray = (Texture2D*) realloc(tileTextureArray, sizeof(Texture2D) * totalTextureNum);
        #endif
    }
    tileTextureArray[tileTextureArraySize] = texture;
    tileTextureArraySize++;
    return (tileTextureArraySize - 1);
}

#if TILE_AUTO_ARRAYSIZE == 0
//!!  MUST BE INITIALIZED  !!
void SetTileTextureArraySize(int size){
    tileTextureArray = (Texture2D*) malloc(sizeof(Texture2D) * size);
    totalTextureNum = size;
}
#endif

//Automatically allocated
Tile AddNewTile(int type){
    //get open slot
    Tile* tileHead = tileTail;

    if(tileHead != NULL){
        while(tileHead->next != NULL){
            tileHead = tileHead->next;
        }
        tileHead->next = (Tile*)malloc(sizeof(Tile));
        tileHead->next->type = type;
        tileHead->next->next = NULL;
        return *tileHead;
    }else{
        tileTail = (Tile*)malloc(sizeof(Tile));
        tileTail->type = type;
        tileTail->next = NULL;
        return *tileTail;
    }
}

void UnloadTileTextureArray(){
    for(int i = 0; i < tileTextureArraySize; i++){
        UnloadTexture(tileTextureArray[i]);
    }
    free(tileTextureArray);
    printf("TILE_INFO: UNLOADTILETEXTUREARRAY: All textures unloaded\n");
}

void UnloadAllTileData(){
    UnloadTileTextureArray();
    
    if(tileTail == NULL) return;
    if(tileTail->next == NULL){
        free(tileTail);
        return;
    }

    Tile* tile = tileTail;
    Tile* tileHead = tileTail->next;

    while(tile != NULL){
        tileHead = tile->next;
        free(tile);
        tile = tileHead;
    }

    printf("TILE_INFO: UNLOADALLTILEDATA: All tiles freed (unloaded)\n");
}
