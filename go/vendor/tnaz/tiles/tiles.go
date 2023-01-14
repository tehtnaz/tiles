package tiles

import (
	rl "github.com/gen2brain/raylib-go/raylib"
)

type Tile struct {
	tileType int
}

var tileList []Tile
var tileTextureList []rl.Texture2D

func DrawTextureBackground(tex rl.Texture2D, scale float32, tint rl.Color) {
	rl.DrawTextureTiled(
		tex,
		rl.Rectangle{X: 0, Y: 0, Width: float32(tex.Width), Height: float32(tex.Height)},
		rl.Rectangle{X: 0, Y: 0, Width: float32(rl.GetScreenWidth()), Height: float32(rl.GetScreenHeight())},
		rl.Vector2{X: 0, Y: 0}, 0, scale, tint)
}
func DrawTileBackground(tile Tile, scale float32, tint rl.Color) {
	rl.DrawTextureTiled(
		tileTextureList[tile.tileType],
		rl.Rectangle{X: 0, Y: 0, Width: float32(tileTextureList[tile.tileType].Width), Height: float32(tileTextureList[tile.tileType].Height)},
		rl.Rectangle{X: 0, Y: 0, Width: float32(rl.GetScreenWidth()), Height: float32(rl.GetScreenHeight())},
		rl.Vector2{X: 0, Y: 0}, 0, scale, tint)
}
func DrawTileVaried(mapWidth int, scale float32, tint rl.Color) {
	if len(tileList) == 0 {
		print("ERROR - goTile : Tried rendering an empty tile list. Skipping...")
		return
	}

	var temp rl.Texture2D
	var posx float32 = 0
	largestHeight := 0
	index := 0

	for i := 0; index < len(tileList); i++ {
		if tileList[index].tileType >= len(tileTextureList) {
			print("GOTILE_ERROR: Tried rendering texture outside of tileTextureArray. Array Size: ", len(tileTextureList), " Requested index: ", tileList[index].tileType, "\n")
			index++
			i--
			continue
		} else {
			temp = tileTextureList[tileList[index].tileType]
		}
		//get largest
		if int(temp.Height) > largestHeight {
			largestHeight = int(temp.Height)
		}
		if (i % mapWidth) == 0 {
			posx = 0
		}
		rl.DrawTextureEx(temp, rl.Vector2{X: posx, Y: float32(i/mapWidth) * float32(largestHeight) * scale}, 0, scale, tint)
		posx += float32(temp.Width) * scale
		print("GOTILE_DEBUG: DrawTileVaried -", posx, " ", i%mapWidth, " ", i, "\n")
		index++
	}
}
func NewTileTexture(tex rl.Texture2D) int {
	print("added new item")
	tileTextureList = append(tileTextureList, tex)
	return len(tileTextureList) - 1
}
func AddNewTile(tileType int) Tile {
	newTile := Tile{tileType: tileType}
	tileList = append(tileList, newTile)
	return newTile
}
func UnloadTileTextureArray() {

}
func UnloadAllTileData() {

}
