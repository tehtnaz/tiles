package main

import (
	tiles "tnaz/tiles"

	rl "github.com/gen2brain/raylib-go/raylib"
)

func main() {
	rl.InitWindow(1920, 1080, "Test")

	tiles.NewTileTexture(rl.LoadTexture("res/crate.png"))
	tiles.NewTileTexture(rl.LoadTexture("res/0.png"))
	tiles.NewTileTexture(rl.LoadTexture("res/crate1.png"))

	tiles.AddNewTile(10)
	tiles.AddNewTile(2)
	tiles.AddNewTile(2)
	tiles.AddNewTile(2)
	tiles.AddNewTile(2)
	tiles.AddNewTile(1)
	tiles.AddNewTile(3)
	tiles.AddNewTile(1)
	tiles.AddNewTile(1)
	tiles.AddNewTile(0)
	tiles.AddNewTile(0)
	tiles.AddNewTile(1)
	tiles.AddNewTile(0)
	tiles.AddNewTile(0)
	tiles.AddNewTile(0)
	tiles.AddNewTile(0)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.RayWhite)
		tiles.DrawTileVaried(4, 5, rl.White)
		rl.EndDrawing()
	}
	tiles.UnloadAllTileData()
	rl.CloseWindow()

}
