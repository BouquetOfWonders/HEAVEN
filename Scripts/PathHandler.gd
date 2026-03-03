extends Node

const N = 1 
const E = 2
const S = 4
const W = 8
var Map
var Pathfinding = AStar2D.new()
var XGlobal
var YGlobal
signal PathGenerated

func GenerateStruckture(x: int, y: int) -> void:
	XGlobal = x
	YGlobal = y
	if not Map:
		Global.ErrorLog.emit(" Pathfinding Fail: \n Mazemap isn't referenced")
		return
	for i in range(y):
		for j in range(x):
			var ID = j + (i * x)
			Pathfinding.add_point(ID,Vector2(j, i))
	var Counter = 0
	for i in range(y):
		for j in range(x):
			var current = Map.get_cell_atlas_coords(Vector2i(j, i))
			current =  _coordstoID(current)
			_HandleConnections(Counter, current, x)
			Counter += 1
	PathGenerated.emit()
	
func FindPath(StartPoint, EndPoint) -> Array:
	StartPoint = _PathfindingCoordstoID(StartPoint, XGlobal)
	EndPoint = _PathfindingCoordstoID(EndPoint, XGlobal)
	var Raw = Pathfinding.get_point_path(StartPoint, EndPoint)
	var Processed: Array
	
	for i in range(Raw.size()):
		Processed.append(Vector2i(Raw[i]))
	return Processed
	
func IsThereAWall(StartPoint, Direction: String) -> bool:
	StartPoint = Map.get_cell_atlas_coords(StartPoint)
	
	if (StartPoint & N) != 0 and Direction == "N":
		return true
	if (StartPoint & E) != 0 and Direction == "E":
		return true
	if (StartPoint & S) != 0 and Direction == "S":
		return true
	if (StartPoint & W) != 0 and Direction == "W":
		return true
	return false
	
func NextStep(StartPoint, EndPoint):
	return FindPath(StartPoint, EndPoint)[1]
	
func _HandleConnections(PointID: int, PointAtlasID: int, x: int) -> void:
	if (PointAtlasID & N) == 0:
		Pathfinding.connect_points(PointID, PointID - x)
	if (PointAtlasID & E) == 0:
		Pathfinding.connect_points(PointID, PointID + 1)
	if (PointAtlasID & S) == 0:
		Pathfinding.connect_points(PointID, PointID + x)
	if (PointAtlasID & W) == 0:
		Pathfinding.connect_points(PointID, PointID - 1)
	return
	
	
func TilesFromSpeed(speed: int, position: Vector2i):
	var ID = _PathfindingCoordstoID(position, XGlobal)
	var PathwaysID = Pathfinding.get_point_connections(ID)
	var AlreadyChecked: Array
	for i in speed:
		for j in PathwaysID.size():
			if not AlreadyChecked.has(PathwaysID[j]):
				AlreadyChecked.append(PathwaysID[j])
				PathwaysID.append_array(Pathfinding.get_point_connections(PathwaysID[j]))
			
	
	PathwaysID = DeleteDuplicates(PathwaysID)
	var Pathways : Array = []
	for i in PathwaysID.size():
		Pathways.append(_IDtoPathfindingCords(PathwaysID[i], XGlobal))
		
		
	Pathways.erase(position)
	
	return Pathways
	
	
func _coordstoID(coords: Vector2i) -> int:
	return coords.x + coords.y * 4
	
func _PathfindingCoordstoID(coords: Vector2i, x: int) -> int:
	return coords.x + coords.y * x
 
func _IDtoPathfindingCords(ID: int, x) -> Vector2i:
	return Vector2i(ID % x, floor(ID/x))
	
func DeleteDuplicates(array: Array) -> Array:
	var unique: Array = []

	for i in array.size():
		if not unique.has(array[i]):
			unique.append(array[i])
	return unique
