extends Control
class_name VisualizationSubMenu

signal call_submenu_switch(path: String)

@export var problemSet: String = ""
@export var days: int = 25

var representPath: String:
	set(str):
		representPath = str
		%LocationLabel.text = representPath

func get_directories_in_directory(path: String) -> PackedStringArray:
	var files: PackedStringArray
	var dir = DirAccess.open(path)
	assert(dir, "Dir couldn't be accessed: " + path)
	
	files = dir.get_directories()
	
	#files.sort()
	return files

func _ready() -> void:
	assert(not (not representPath or representPath == ""), "Need a valid path for the visualization submenu, not '" + representPath + "'!")
	add_selections(representPath)
	
	var repPathSplit: PackedStringArray = representPath.split("/")
	if repPathSplit.size() <= 5: $BackButton.disabled = true
	
	

func add_selections(path: String) -> void:
	var dirSelections: PackedStringArray = get_directories_in_directory(path)
	var sortedNums: Array = []
	if dirSelections[0].contains("Day"):
		var numOrderDict: Dictionary[int, int] = {}
		for dirSel: String in dirSelections:
			var dirNum: int = dirSel.substr(3).to_int()
			numOrderDict[dirNum] = 1
		sortedNums = numOrderDict.keys()
		sortedNums.sort()
	
	if not sortedNums.is_empty():
		for nextDay: int in sortedNums:
			var nextDir: String = "Day" + str(nextDay)
			add_selection(nextDir)
	else:
		for nextDir: String in dirSelections:
			add_selection(nextDir)
	

func call_for_submenu_switch(path: String) -> void:
	#if path == VisualizationMenu.basePath: return
	call_submenu_switch.emit(path)



func add_selection(path: String) -> void:
	var dirPath: String = representPath + path + "/"
	var leadingSelection: VisualizationMenuSelection = Instantiate.scene(VisualizationMenuSelection)
	leadingSelection.set_path(dirPath)
	
	var selTypeInit: int = (dirPath.split("/").size()-VisualizationMenu.basePath.split("/").size())
	var selType: VisualizationMenuSelection.SelectionType = selTypeInit as VisualizationMenuSelection.SelectionType
	leadingSelection.selectionType = selType
	leadingSelection.head_into_path.connect(call_for_submenu_switch)
	
	$GridContainer.add_child(leadingSelection)


func _on_back_button_pressed() -> void:
	var repPathSplit: PackedStringArray = representPath.split("/")
	var charRemoveAmount: int = repPathSplit[repPathSplit.size()-2].length() + 1
	var backPath: String = representPath.left(charRemoveAmount * -1)
	print(backPath)
	call_for_submenu_switch(backPath)
