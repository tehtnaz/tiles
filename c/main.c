#include "raylib.h"
#include "src/config.h"
#include "src/tile.h"

#include <stdio.h>
#include <stdarg.h>

//Example Project


int main(){
    InitWindow(1920, 1080, "Test");

    NewTileTexture(LoadTexture("res/crate.png"));
    NewTileTexture(LoadTexture("res/0.png"));
    NewTileTexture(LoadTexture("res/crate1.png"));

    AddNewTile(10);
    AddNewTile(2);
    AddNewTile(2);
    AddNewTile(2);
    AddNewTile(2);
    AddNewTile(1);
    AddNewTile(3);
    AddNewTile(1);
    AddNewTile(1);
    AddNewTile(0);
    AddNewTile(0);
    AddNewTile(1);
    AddNewTile(0);
    AddNewTile(0);
    AddNewTile(0);
    AddNewTile(0);

    while(!WindowShouldClose()){
        BeginDrawing();
            ClearBackground(RAYWHITE);
            DrawTileVaried(4, 5, WHITE);
        EndDrawing();
    }
    UnloadAllTileData();
    CloseWindow();
}