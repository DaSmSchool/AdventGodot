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
	
	return ""

func run_solutions(scriptPath: String) -> void:
	var adventInput: String = get_input_from_solution_path(scriptPath)
	$HBoxContainer/RawSolutionPartSolver.solve_given_solution(scriptPath, 1, adventInput)
	$HBoxContainer/RawSolutionPartSolver2.solve_given_solution(scriptPath, 2, adventInput)
	
	
