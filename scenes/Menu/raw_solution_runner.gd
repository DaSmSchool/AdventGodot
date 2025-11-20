extends Control
class_name RawSolutionRunner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_input_from_solution_path(scriptPath: String) -> String:
	var scriptPathSplit: PackedStringArray = scriptPath.split("/")
	var scriptNameSupersplit: PackedStringArray = scriptPathSplit[scriptPathSplit.size()-1].split("Day") 
	
	var problemSet: String = scriptNameSupersplit[0]
	var day: String = scriptNameSupersplit[1].split(".")[0]
	
	var targetInputPath: String = "res://input/%s/D%s.txt" % [problemSet, day]
	if FileAccess.file_exists(targetInputPath):
		return FileAccess.get_file_as_string(targetInputPath)
	
	return ""

func run_solutions(scriptPath: String) -> void:
	var adventInput: String = get_input_from_solution_path(scriptPath)
	assert(adventInput != "", "No input given!!")
	
	var partSolver1: RawSolutionPartSolver = Instantiate.scene(RawSolutionPartSolver)
	$HBoxContainer.add_child(partSolver1)
	var partSolver2: RawSolutionPartSolver = Instantiate.scene(RawSolutionPartSolver)
	$HBoxContainer.add_child(partSolver2)
	
	for i: int in range(1, 3):
		$HBoxContainer.get_child(i-1).solve_given_solution(scriptPath, i, adventInput)
	
	


func _on_exit_button_pressed() -> void:
	for child: Node in $HBoxContainer.get_children():
		child.queue_free()
	get_tree().current_scene.raw_solution_to_menu()
