extends Control
class_name VisualizationMenuSelection

enum SelectionType {
	NONE,
	YEAR,
	DAY,
	SOLUTION
}

@export var selectionType: SelectionType = SelectionType.NONE


func _on_visualization_pressed() -> void:
	Object
	assert(selectionType != SelectionType.NONE, "I wasn't set to a correct selection type!")
	
