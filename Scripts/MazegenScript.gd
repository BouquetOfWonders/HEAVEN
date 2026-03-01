extends Node2D

signal MazeGenerated

const N = 1 
const E = 2
const S = 4
const W = 8

var CellWalls = {Vector2i(0, -1): N, Vector2i(1, 0): E, Vector2i(0, 1): S, Vector2i(-1, 0): W}

var TileSize := 65
var width := 10
var height := 10

var END : Vector2i
var SPAWN: Vector2i

@onready var Map = $MazeMap
@onready var Special = $SpecialMap

var RNG = RandomNumberGenerator.new()

func _ready() -> void:
	RNG.seed = hash("awesome")
	PathHandler.Map = $MazeMap
	generateMaze(false)
	
func generateMaze(DoGraphics: bool) -> void:
	var unvisitedList := []
	var specialList := []
	var stack := []
	SPAWN = Vector2i(0, 0)
	if SPAWN.y >= height or SPAWN.x >= width:
		Global.ErrorLog.emit(" Spawn outisde of borders \n Can't Generate Maze")
		return
	Map.clear()
	Special.clear()
	var IsSpecial = true
	for x in range(width):
		for y in range(height):
			unvisitedList.append(Vector2i(x, y))
			Map.set_cell(Vector2i(x, y), 0, IDtoCoords(N|E|S|W))
	var current = SPAWN
	unvisitedList.erase(current)
	while unvisitedList:
		
		var neighbours = checkNeighbors(current, unvisitedList)
		if neighbours.size() > 0:
			IsSpecial = true
			var rando = RNG.randi_range(0, neighbours.size() - 1) 
			var next = neighbours[rando]
			stack.append(current)
			var dir = next - current
			var current_walls = Map.get_cell_atlas_coords(current)
			var next_walls = Map.get_cell_atlas_coords(next)
			Map.set_cell(current, 0, IDtoCoords(coordstoID(current_walls) - CellWalls[dir]))
			Map.set_cell(next, 0, IDtoCoords(coordstoID(next_walls) - CellWalls[-dir]))
			current = next
			unvisitedList.erase(current)
		elif stack:
			if IsSpecial:
				specialList.append(current)
				IsSpecial = false
			current = stack.pop_back()
			
		if DoGraphics:
			Special.clear()
			Special.set_cell(current, 1, Vector2i(1, 1))
			await get_tree().create_timer(0.05).timeout
		
	specialList.append(current)
	generateSpecial(specialList, SPAWN)
	PathHandler.GenerateStruckture(width, height)
	MazeGenerated.emit()
	await get_tree().create_timer(3).timeout

func checkNeighbors(currentCell, unvisitedList) -> Array:
	var list := []
	for n in CellWalls.keys():
		if currentCell + n in unvisitedList:
			list.append(currentCell + n)
	return list

func IDtoCoords(ID) -> Vector2i:
	return Vector2i(ID % 4, ceil(ID/4))
	
func coordstoID(coords: Vector2i) -> int:
	return coords.x + coords.y * 4
	
func generateSpecial(List: Array, Spawn: Vector2i) -> void:
	Special.set_cell(Spawn, 1, Vector2i(0, 0))
	var randomTile = List[RNG.randi_range(0, List.size() - 1)]
	List.erase(randomTile)
	Special.set_cell(randomTile, 1, Vector2i(0, 1))
	END = randomTile
	for i in range(List.size()):
		Special.set_cell(List[i], 1, Vector2i(1, 0))
	Global.SPAWN = SPAWN
	Global.END = END
	Global.SPECIAL = List
	print(Global.SPAWN)
	print(Global.END)
	print(Global.SPECIAL)
