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

func _on_visualization_pressed() -> void:
	assert(selectionType != SelectionType.NONE, "'" + name + "'" + " wasn't set to a valid selection type!")
	head_into_path.emit(representPath)
