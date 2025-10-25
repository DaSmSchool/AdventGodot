extends Control
class_name VisualizationMenu

static var basePath: String = "res://scenes/Solutions/"

func _ready() -> void:
	var initMenu: VisualizationSubMenu = get_submenu(basePath)
	print(initMenu.representPath)
	$VizualizationMenus.add_child(initMenu)
	
func get_submenu(path: String) -> VisualizationSubMenu:
	var initMenu: VisualizationSubMenu = Instantiate.scene(VisualizationSubMenu)
	initMenu.representPath = path
	initMenu.problemSet = path.split("/")[4]
	initMenu.call_submenu_switch.connect(replace_submenu)
	return initMenu

func replace_submenu(newPath: String) -> void:
	var newSubmenu: VisualizationSubMenu = get_submenu(newPath)
	$VizualizationMenus.add_child(newSubmenu)
	$VizualizationMenus.get_child(0).queue_free()
