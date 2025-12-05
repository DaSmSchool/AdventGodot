@tool
extends Control
class_name AdventPlugin

@export var yearEdit: LineEdit
@export var dayEdit: LineEdit

func make_script() -> void:
	var dirPath: String = "res://scenes/Solutions/%s/Day%s/RawSolution/" % [yearEdit.text, dayEdit.text]
	var filePath: String = dirPath + "%sDay%s.gd" % [yearEdit.text, dayEdit.text]
	#print(dirPath)
	var dirAcc: Error = DirAccess.make_dir_recursive_absolute(dirPath)
	#print(dirAcc)
	if not FileAccess.file_exists(filePath):
		var scriptTemplate: FileAccess = FileAccess.open("res://script_templates/Solution/solution_base.gd", FileAccess.READ)
		var content = scriptTemplate.get_as_text()
		var newScript = FileAccess.open(filePath, FileAccess.WRITE)
		newScript.store_string(content)
		scriptTemplate.close()
		newScript.close()

func make_blank_input_file() -> void:
	var dirPath: String = "res://input/%s/" % yearEdit.text
	var filePath: String = dirPath + "D%s.txt" % dayEdit.text
	#print(dirPath)
	var dirAcc: Error = DirAccess.make_dir_recursive_absolute(dirPath)
	#print(dirAcc)
	if not FileAccess.file_exists(filePath):
		var newText = FileAccess.open(filePath, FileAccess.WRITE)
		newText.close()

func _on_create_button_pressed() -> void:
	make_script()
	make_blank_input_file()
	EditorInterface.get_resource_filesystem().scan()
