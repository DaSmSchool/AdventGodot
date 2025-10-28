extends Control
class_name RawSolutionRunner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func run_solutions(problemSet: String, day: int, adventInput: String) -> void:
	var scriptPath: String = ""
	$HBoxContainer/RawSolutionPartSolver.solve_given_solution(scriptPath, 1, adventInput)
	$HBoxContainer/RawSolutionPartSolver2.solve_given_solution(scriptPath, 2, adventInput)
	
	
