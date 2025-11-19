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
	$HBoxContainer/RawSolutionPartSolver.solve_given_solution(scriptPath, 1, adventInput)
	$HBoxContainer/RawSolutionPartSolver2.solve_given_solution(scriptPath, 2, adventInput)
	
	
