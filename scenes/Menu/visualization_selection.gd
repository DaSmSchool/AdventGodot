extends Control
class_name VisualizationMenuSelection

signal head_into_path(path: String)

enum SelectionType {
	NONE,
	YEAR,
	DAY,
	SOLUTION
}

@export var selectionType: SelectionType = SelectionType.NONE
var representPath: String = ""

func _ready() -> void:
	set_from_path()
	
	
func set_from_path() -> void:
	var splitList: PackedStringArray = representPath.split("/")
	$Visualization.text = splitList[splitList.size()-2]
	pass

func set_path(path: String) -> void:
	assert(not ResourceLoader.exists(path), "'" + path + "'" + " isn't a valid path!")
	representPath = path

func is_solution_raw() -> String:
	var dir: DirAccess = DirAccess.open(representPath)
	var dirFiles: PackedStringArray = dir.get_files()
	var gdInd: int = -1
	for fileInd: int in dirFiles.size():
		if dirFiles[fileInd].ends_with(".gd"):
			if gdInd != -1:
				gdInd = -1
				break
			gdInd = fileInd
			
	if gdInd != -1:
		return representPath + dirFiles[gdInd]
	
	return ""

func is_solution_visualization() -> String:
	var dir: DirAccess = DirAccess.open(representPath)
	if dir.get_files().has("main.tscn"): return representPath + "main.tscn"
	return ""

func _on_visualization_pressed() -> void:
	assert(selectionType != SelectionType.NONE, "'" + name + "'" + " wasn't set to a valid selection type!")
	if selectionType != SelectionType.SOLUTION:
		head_into_path.emit(representPath)
	else:
		var rawSol: String = is_solution_raw()
		var visSol: String = is_solution_visualization()
		if rawSol != "":
			var rootNode: Node = get_tree().current_scene
			assert(rootNode is AdventMenuControl, "Root node isn't AdventMenuControl")
			(rootNode as AdventMenuControl).run_raw_advent_solution(rawSol)
		elif visSol != "":
			var rootNode: Node = get_tree().current_scene
			assert(rootNode is AdventMenuControl, "Root node isn't AdventMenuControl")
			(rootNode as AdventMenuControl).run_advent_visualization(visSol)
		else:
			pass
